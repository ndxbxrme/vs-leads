'use strict'

crypto = require 'crypto-js'
http = require 'http'
superagent = require 'superagent'
async = require 'async'
objtrans = require 'objtrans'

module.exports = (ndx) ->
  templates =
    sellingLetting:
      date: true
      uid: (input) ->
        'gv26:' + input.id
      email: '2'
      user: (input) ->
        title: input['5']
        last_name: input['1']
        phone_day: input['3']
      comments: '6'
      roleId: '13'
      rightmoveId: 'roleId'
      "property": (input) ->
        address: input['15']
        address2: input['16']
        town: input['17']
        county: input['18']
        postcode: input['20']        
      roleType: '11'
      price: '14'
      source: ->
        'gravity'
      method: ->
        'web'
    valuation:
      date: true
      uid: (input) ->
        'gv16:' + input.id
      email: '3'
      user: (input) ->
        title: input['1.2']
        first_name: input['1.3']
        last_name: input['1.6']
        phone_day: input['4']
      comments: (input) ->
        'Property Type: ' + input['16']  + '\n'
        'Bedrooms: ' + input['18']  + '\n'
        'Bathrooms: ' + input['20']  + '\n'
        'Receptions: ' + input['19']  + '\n'
        'Other Info: ' + input['12']  + '\n'
        'Preferred date 1: ' + input['22'] + ' @ ' + input['44']  + '\n'
        'Preferred date 2: ' + input['25'] + ' @ ' + input['26']  + '\n'
        'Comments: ' + input['27']  + '\n'
      property: (input) ->
        address: input['15.1']
        address2: input['15.2']
        town: input['15.3']
        county: input['15.4']
        postcode: input['15.5']
      roleType: ->
        'Valuation'
      source: ->
        'gravity'
      method: ->
        'web'
    offer:
      date: 'date_created'
      uid: (input) ->
        'gv31:' + input.id
      email: '4'
      telephone: '5'
      applicant: (input) ->
        input['2.2'] + ' ' + input['2.3'] + ' ' + input['2.6']
      applicant2: (input) ->
        return '' if not input['31.2']
        (input['31.2'] + ' ' + input['31.3'] + ' ' + input['31.6']).trim()
      applicantAddress: (input) ->
        input['3.1'] + ', ' + input['3.2'] + ', ' + input['3.3'] + ', ' + input['3.5']
      propertyId: '49'
      offerAmount: '9'
      movingPosition: '6'
      financialPosition: '7'
      hasConveyancer: '17'
      comments: '12'
      roleId: (input) ->
        ((input['59'] or '').match(/role_id" value="([^"]+)"/) or [null, ''])[1]
      address: (input) ->
        ((input['59'] or '').match(/prop_address" value="([^"]+)"/) or [null, ''])[1]
      image: (input) ->
        ((input['59'] or '').match(/prop_image" value="([^"]+)"/) or [null, ''])[1]
      price: (input) ->
        ((input['59'] or '').match(/prop_price" value="([^"]+)"/) or [null, ''])[1]
      uploads: (input) ->
        Object.keys(input).map (key) ->
          val = input[key]
          if val and val.toString().includes('uploads/gravity_forms')
            return
              key: key,
              file: val
          null
        .filter (file) -> file

      
  insertLead = (lead, cb) ->
    ndx.database.select 'leads',
      uid: lead.uid
    , (leads) ->
      if leads and leads.length
        cb()
      else
        ndx.database.insert 'leads', lead
        cb()
    , true
      
  insertOffer = (offer, cb) ->
    ndx.database.select 'offers',
      uid: offer.uid
    , (offers) ->
      if offers and offers.length
        cb()
      else
        if offer.roleId
          console.log 'inserting offer', offer.roleId
          ndx.database.insert 'offers', offer
          #send email
          ndx.database.selectOne 'emailtemplates', name: 'New Offer'
          .then (template) ->
            return if not template
            template.offer = offer
            template.to = 'sales@vitalspace.co.uk'
            ndx.email.send template
        cb()
    , true
  
  
  CalculateSig = (stringToSign, privateKey) ->
    hash = crypto.HmacSHA1 stringToSign, privateKey
    base64 = hash.toString(crypto.enc.Base64)
    encodeURIComponent base64
  doGravity = (formNo, gravityCb) ->
    try
      d = new Date()
      expiration = 3600
      unixtime = parseInt(d.getTime() / 1000)
      future_unixtime = unixtime + expiration
      publicKey = process.env.GRAVITY_PUBLIC_KEY.trim()
      privateKey = process.env.GRAVITY_PRIVATE_KEY.trim()
      method = "GET"
      route = "forms/#{formNo}/entries"
      stringToSign = publicKey + ":" + method + ":" + route + ":" + future_unixtime
      sig = CalculateSig stringToSign, privateKey
      console.log "contacting gravity"
      superagent.get "https://vitalspace.co.uk/gravityformsapi/forms/#{formNo}/entries?api_key=#{publicKey}&signature=#{sig}&expires=#{future_unixtime}"
      .end (err, res) ->
        if err
          #console.log 'error', err
          gravityCb()
        else
        #console.log 'response', res.body.response
        if res.body.response and res.body.response.entries
          async.each res.body.response.entries, (item, itemCallback) ->
            item.date = new Date(item.date_created).valueOf()
            #item.roleType = item['11']
            if formNo is 26
              insertLead objtrans(item, templates.sellingLetting), itemCallback
            else if formNo is 16
              insertLead objtrans(item, templates.valuation), itemCallback
            else if formNo is 31
              if item['59']
                insertOffer objtrans(item, templates.offer), itemCallback
            else
              itemCallback()
          , ->
            gravityCb()
        else
          gravityCb()
    catch e
      console.log 'gravity error'
  ndx.gravity =
    fetch: ->
      doGravity 26, ->
        doGravity 16, ->
          doGravity 31, ->
        #console.log 'gravity done'
  ndx.database.on 'ready', ->
    #ndx.database.delete 'offers'
    setInterval ndx.gravity.fetch, 5 * 60 * 1000
    ndx.gravity.fetch()