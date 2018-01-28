'use strict'

angular.module 'vs-leads'
.factory 'message', ->
  messages =
    #general
    "currency": '£'
    "forms-submit": 'Submit'
    "forms-cancel": 'Cancel'
    #header
    "header-logo": 'header'
    #paging
    "paging-text-pre": 'Showing'
    "paging-text-post": 'items per page'
    "paging-total-label": 'Total:'
    #menu
    "menu-dashboard": 'Dashboard'
    "menu-selling": 'Selling'
    "menu-letting": 'Letting'
    "menu-valuation": 'Valuation'
    "menu-history": 'Historic'
    "menu-lead-new": 'Add a Lead'
    "menu-setup": 'Setup'
    "menu-logout": 'Log out'
    #dashboard
    "dashboard-heading": 'Dashboard'
    "dashboard-table-selling-heading": 'Sales Leads'
    "dashboard-table-selling-status": 'Status'
    "dashboard-table-selling-position": 'Lead Position'
    "dashboard-table-selling-today": 'Today\'s Leads'
    "dashboard-table-selling-outstanding": 'Outstanding Leads'
    "dashboard-table-selling-total": 'Total'
    "dashboard-table-letting-heading": 'Lettings Leads'
    "dashboard-table-letting-status": 'Status'
    "dashboard-table-letting-position": 'Lead Position'
    "dashboard-table-letting-today": 'Today\'s Leads'
    "dashboard-table-letting-outstanding": 'Outstanding Leads'
    "dashboard-table-letting-total": 'Total'
    "dashboard-table-valuation-heading": 'Valuation Leads'
    "dashboard-table-valuation-status": 'Status'
    "dashboard-table-valuation-position": 'Lead Position'
    "dashboard-table-valuation-today": 'Today\'s Leads'
    "dashboard-table-valuation-outstanding": 'Outstanding Leads'
    "dashboard-table-valuation-total": 'Total'
    #leads
    "leads-table-source": 'Lead Source'
    "leads-table-address": 'Property Address'
    "leads-table-applicant": 'Applicant'
    "leads-table-date": 'Enquiry Date'
    "leads-table-options": 'Options'
    "leads-button-view-lead": 'View Lead'
    "leads-button-add": 'Add a Lead'
    "leads-Valuation-heading": 'Valuation lead management'
    "leads-Selling-heading": 'Sales lead management'
    "leads-Letting-heading": 'Lettings lead management'
    "leads-message-no-items": 'No leads to show'
    #lead
    "lead-heading": 'Lead'
    "lead-contact-details-heading": 'Contact Details'
    "lead-comments-heading": 'Additional Comments'
    "lead-notes-heading": 'Notes about this lead'
    "lead-addressSection-label": 'Address'
    "lead-email-label": 'Email'
    "lead-heading-adding": 'Adding a lead'
    "lead-heading-editing": 'Editing a lead'
    "lead-method-label": 'Source'
    "lead-method-error-required": 'Please select a source'
    "lead-name-label": 'Applicant'
    "lead-phone-label": ' '
    "lead-source-label": ' '
    "lead-useraddress-label": 'Street Address'
    "lead-useraddress-error-required": 'Please enter an address'
    "lead-useraddress2-label": 'Address Line 2'
    "lead-userfirst_name-label": 'First Name'
    "lead-userfirst_name-error-required": 'Please enter a first name'
    "lead-userlast_name-label": 'Last Name'
    "lead-userlast_name-error-required": 'Please enter a last name'
    "lead-userphone_day-label": 'Phone'
    "lead-userpostcode-label": 'Postcode'
    "lead-userpostcode-error-required": 'Please enter a postcode'
    "lead-usertitle-label": 'Title'
    "lead-usertitle-error-required": 'Please enter a title'
    "lead-property-label": 'Interested in Viewing'
    "lead-selectedProperty-label": 'Property'
    "lead-selectedProperty-error-required": 'Please select a property'
    "lead-delete-button": 'Delete Lead'
    "lead-booking-button": 'Lead Booked'
    "lead-restore-button": 'Restore Lead'
    "lead-delete-title": 'Delete Lead'
    "lead-delete-message": 'Are you sure you want to delete this lead?'
    #history
    "history-heading": 'Historic Leads'
    "history-table-address": 'Property Address'
    "history-table-applicant": 'Applicant Name'
    "history-table-date": 'Enquiry Date'
    "history-table-status": 'Status'
    "history-table-view": 'View Lead'
    "history-table-restore": 'Restore Lead'
    "history-message-no-items": 'No leads to show'
    #setup
    "setup-heading": 'Setup'
    #email template
    "template-name-label": 'Name'
    "template-name-error-required": 'Please enter a name'
    "template-subject-label": 'Action'
    "template-subject-error-required": 'Please enter a subject'
    "template-from-label": 'Action'
    "template-from-error-required": 'Please enter a from email address'
    "template-from-error-email": 'Please enter a valid email address'
    "template-action-label": 'Action'
    "template-action-error-required": 'Please select an action'

  fillTemplate = (template, data) -> 
    template.replace /\{\{(.+?)\}\}/g, (all, match) ->
      evalInContext = (str, context) ->
        (new Function("with(this) {return #{str}}"))
        .call context
      evalInContext match, data
  m = (key, obj) ->
    if messages[key]
      return if obj then fillTemplate(messages[key], obj) else messages[key]
    if /-placeholder$/.test key
      key = key.replace 'placeholder', 'label'
      if messages[key]
        return if obj then fillTemplate(messages[key], obj) else messages[key]
    console.log key
  m: m
.run ($rootScope, message) ->
  root = Object.getPrototypeOf $rootScope
  root.m = message.m
