'use strict'

angular.module 'vs-leads'
.controller 'TemplateCtrl', ($scope, $stateParams, $state, $http, env) ->
  $scope.type = $stateParams.type
  $scope.defaultLast = 'setup'
  cb = (template) ->
    if template
      $scope.template.locked = true
  if $stateParams.type is 'email'
    $scope.lang = 'jade'
    $scope.template = $scope.single 'emailtemplates', $stateParams.id, cb
  else
    $scope.lang = 'text'
    $scope.template = $scope.single 'smstemplates', $stateParams.id, cb
    
  $scope.emailActions =
    items: [
      _id: 'leadAdded'
      name: 'Lead added'
    ,
      _id: 'leadBooked'
      name: 'Lead booked'
    ,
      _id: 'leadDeleted'
      name: 'Lead deleted'
    ,
      _id: 'valuationAdded'
      name: 'Valuation added'
    ,
      _id: 'valuationBooked'
      name: 'Valuation booked'
    ,
      _id: 'valuationDeleted'
      name: 'Valuation deleted'
    ]
  $scope.sendTo =
    items: [
      _id: 'applicant'
      name: 'Applicant'
    ,
      _id: 'admin'
      name: 'Admin'
    ,
      _id: 'agency'
      name: 'Agency'
    ]
    
  $scope.defaultData = 
    lead: 
      'date': 1516950731000
      'uid': 'rm165564926'
      'email': 'bgfountain@gmail.com'
      'user':
        'title': 'Mr'
        'address': '5 Cartwright Road'
        'postcode': 'M21 9EY'
        'country': 'GB'
        'first_name': 'Ben'
        'last_name': 'Fountain'
        'phone_day': '07796266255'
        'phone_evening': null
        'dpa_flag': false
      'comments': 'Hello,\u000d\nI\'d like to view the property. Is there any chance of a viewing either over this weekend, or next Wednesday?'
      'roleId': 8546607
      'propertyId': 947606
      'rightmoveId': 70011173
      'property':
        'address': '26 Newcroft Road'
        'address2': 'Urmston'
        'town': 'Manchester'
        'county': ''
        'postcode': 'M41 9NN'
      'roleType': 'Selling'
      'price': 270000
      'source': 'rightmove'
      'method': 'email'
      'insertedAt': 1517130025895
      'modifiedAt': 1517130025895
      'applicant': 'Mr Ben Fountain'
      's': 'mr ben fountain|26 newcroft road|m41 9nn'
      '_id': '5a6d91293771932fbceee4d5'
    user:
      'local':
        'email': 'test@test.com'
        'password': '$2a$08$zx6DMb.u4rNBF2BH5oqPgeZdwgyMfhusIxD2CwTvPpBLACELRiJOa'
      'roles': 'agency': {}
      'displayName': 'Test User'
      'telephone': '235'
      'insertedAt': 1516825280173
      'modifiedAt': 1516825280173
      'insertedBy': '5a68e93dc8ca2a148c5f88ee'
      'modifiedBy': '5a68e93dc8ca2a148c5f88ee'
      '_id': '5a68eac04df69819f8a04157'