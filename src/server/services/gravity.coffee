'use strict'

crypto = require 'crypto-js'
http = require 'http'

module.exports = (ndx) ->
  CalculateSig = (stringToSign, privateKey) ->
    hash = crypto.HmacSHA1 stringToSign, privateKey
    base64 = hash.toString(crypto.enc.Base64)
    encodeURIComponent base64
  d = new Date()
  expiration = 3600
  unixtime = parseInt(d.getTime() / 1000)
  future_unixtime = unixtime + expiration
  publicKey = process.env.GRAVITY_PUBLIC_KEY.trim()
  privateKey = process.env.GRAVITY_PRIVATE_KEY.trim()
  method = "GET"
  route = "forms/3/entries"
  stringToSign = publicKey + ":" + method + ":" + route + ":" + future_unixtime
  #privateKey = 'abcd'
  #stringToSign = "1234:GET:forms/1/entries:1369749344"
  console.log 'string:', stringToSign
  sig = CalculateSig stringToSign, privateKey
  console.log 'signature:', sig
  options =
    hostname: 'vitalspace.co.uk'
    path: "/gravityformsapi/forms/3?api_key=#{publicKey}&signature=#{sig}&expires=#{future_unixtime}"
    method: method
  console.log "http://#{options.hostname}#{options.path}"
  req = http.request options, (res) ->
    output = ''
    res.on 'data', (data) ->
      console.log 'data'
      output += data.toString 'utf8'
    res.on 'end', (d) ->
      console.log d
      console.log 'res end', output
  req.end()