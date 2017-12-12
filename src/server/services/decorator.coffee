'use strict'

module.exports = (ndx) ->
  decorate = (args, cb) ->
    if args.obj.deleted
      return cb()
    switch args.table
      when 'leads'
        args.obj.applicant = "#{args.obj.user.title or ''} #{args.obj.user.first_name or ''} #{args.obj.user.last_name or ''}".trim()
        args.obj.s = "#{args.obj.applicant.toLowerCase()}|#{(args.obj.property?.address || args.obj.user.address).toLowerCase()}|#{(args.obj.property?.postcode || args.obj.user.postcode).toLowerCase()}"
        cb true
      else
        cb true
  setImmediate ->
    ndx.database.on 'preInsert', decorate
    ndx.database.on 'preUpdate', decorate