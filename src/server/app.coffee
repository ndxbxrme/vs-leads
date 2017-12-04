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
.start()
