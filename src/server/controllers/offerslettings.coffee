'use strict'

module.exports = (ndx) ->
  ndx.app.get '/api/offerpdf/:id', (req, res, next) ->
    applicationId = req.params.id
    formData = await ndx.database.selectOne 'offerslettings',
      uid: applicationId
    if !formData
      return res.status(404).send('Application not found')
    doc = new PDFDocument
    res.setHeader 'Content-Type', 'application/pdf'
    res.setHeader 'Content-Disposition', 'attachment; filename="application_' + applicationId + '.pdf"'
    doc.pipe res
    doc.fontSize(18).text 'New Tenancy Application', align: 'center'
    doc.moveDown()

    addSection = (title, fields) ->
      doc.fontSize(14).text title, underline: true
      doc.moveDown 0.5
      Object.entries(fields).forEach (key, value) ->
        doc.fontSize(11).text key.replace(/_/g, ' ') + ':' + value or '-'
        return
      doc.moveDown()
      return

    addSection 'Applicant Details', formData.user
    addSection 'Employment Information', formData.employment
    addSection 'Address Information',
      'Current Address Street': formData.address.current_address.street
      'Current Address Town': formData.address.current_address.town
      'Current Address Postcode': formData.address.current_address.postcode
      'Future Address': formData.address.future_address
      'Previous Address': formData.address.previous_address
    addSection 'Preferences', formData.preferences
    addSection 'Rent Details', formData.rent_details
    doc.fontSize(11).text if 'Consent Given: ' + formData.consent then 'Yes' else 'No'
    doc.text 'Submitted via: ' + formData.source
    doc.text 'Method: ' + formData.method
    doc.end()
    return