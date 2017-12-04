'use strict'

angular.module 'vs-leads'
.config ($stateProvider) ->
  $stateProvider.state 'lead-new',
    url: '/lead'
    templateUrl: 'routes/lead/lead.html'
    controller: 'LeadCtrl'
    params:
      _id: null
    data:
      title: 'lead'
      auth: ['superadmin', 'admin', 'agency']
  $stateProvider.state 'lead',
    url: '/lead/:_id'
    templateUrl: 'routes/lead/lead.html'
    controller: 'LeadCtrl'
    data:
      title: 'lead'
      auth: ['superadmin', 'admin', 'agency']