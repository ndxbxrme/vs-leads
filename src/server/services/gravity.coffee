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
        'gv7:' + input.id
      email: '2'
      user: (input) ->
        title: input['5']
        last_name: input['1']
        phone_day: input['3']
      comments: '6'
      roleId: true
      propertyId: true
      rightmoveId: 'roleId'
      "property": (input) ->
        if input and input.prop
          address: "#{input.prop.Address.Number or input.prop.Address.BuildingName} #{input.prop.Address.Street}"
          address2: "#{input.prop.Address.Locality}"
          town: input.prop.Address.Town
          county: input.prop.Address.County
          postcode: input.prop.Address.Postcode        
      roleType: true
      price: true
      source: ->
        'gravity'
      method: ->
        'web'
    valuation:
      date: true
      uid: (input) ->
        'gv3:' + input.id
      email: '3'
      user: (input) ->
        title: input['1.2']
        first_name: input['1.3']
        last_name: input['1.6']
        phone_day: input['4']
      comments: (input) ->
        'When to call: ' + input['5']  + '\n'
        'Comments: ' + input['6']  + '\n'
        'Property Type: ' + input['8']  + '\n'
        'Bedrooms: ' + input['9']  + '\n'
        'Bathrooms: ' + input['10']  + '\n'
        'Receptions: ' + input['11']  + '\n'
        'Other Info: ' + input['12']  + '\n'
        'Preferred date: ' + input['13'] + ' @ ' + input['14']  + '\n'
      property: (input) ->
        address: input['2.1']
        address2: input['2.2']
        town: input['2.3']
        county: input['2.4']
        postcode: input['2.5']
      roleType: ->
        'Valuation'
      source: ->
        'gravity'
      method: ->
        'web'
      
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
  
  CalculateSig = (stringToSign, privateKey) ->
    hash = crypto.HmacSHA1 stringToSign, privateKey
    base64 = hash.toString(crypto.enc.Base64)
    encodeURIComponent base64
  doGravity = (formNo, gravityCb) ->
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
    superagent.get "http://vitalspace.co.uk/gravityformsapi/forms/#{formNo}/entries?api_key=#{publicKey}&signature=#{sig}&expires=#{future_unixtime}"
    .end (err, res) ->
      if err
        #console.log err
        gravityCb()
      else
        if res.body.response and res.body.response.entries
          async.each res.body.response.entries, (item, itemCallback) ->
            item.date = new Date(item.date_created).valueOf()
            if formNo is 7 and item['7'] and item['8']
              ndx.dezrez.get 'role/{id}', null, id: item['7'], (err, body) ->
                return itemCallback() if err or not body
                item.roleType = body.RoleType.SystemName
                item.roleId = +item['7']
                item.propertyId = body.PropertyId
                item.price = body.Price?.PriceValue
                item.property = {}
                ndx.dezrez.get 'property/{id}', null, id:body.PropertyId, (err, body) ->
                  item.property.prop = body
                  insertLead objtrans(item, templates.sellingLetting), itemCallback
            else if formNo is 3
              insertLead objtrans(item, templates.valuation), itemCallback
            else
              itemCallback()
          , ->
            gravityCb()
        else
          gravityCb()
  ndx.gravity =
    fetch: ->
      doGravity 7, ->
        doGravity 3, ->
        #console.log 'gravity done'
  ndx.database.on 'ready', ->
    #ndx.database.delete 'leads'
    setInterval ndx.gravity.fetch, 5 * 60 * 1000
    ndx.gravity.fetch()