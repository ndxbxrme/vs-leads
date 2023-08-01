'use strict'

require 'ndx-server'
.config
  database: 'db'
  tables: ['users', 'leads', 'shorttoken', 'emailtemplates']
  localStorage: './data'
  hasInvite: true
  hasForgot: true
  insertField: 'insertedAt'
  insertUserField: 'insertedBy'
  softDelete: true
  autoRestart: false
.use (ndx) ->
  ndx.app.post '/api/mailin', (req, res) ->
    try
      lead = await ndx.database.selectOne 'leads', email: req.body.sender
      if lead
        template = await ndx.database.selectOne 'emailtemplates', name: 'Auto Response - ' + lead.roleType
        if template
          template.to = req.body.sender
          template.lead = lead
          ndx.email.send template
    catch e
      console.log e
    res.end 'OK'
.start()
