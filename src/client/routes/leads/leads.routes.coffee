'use strict'

angular.module 'vs-leads'
.config ($stateProvider) ->
  $stateProvider.state 'leads',
    url: '/leads'
    templateUrl: 'routes/leads/leads.html'
    controller: 'LeadsCtrl'
    data:
      title: 'leads'
      auth: ['superadmin', 'admin', 'agency']
  $stateProvider.state 'selling',
    url: '/selling'
    templateUrl: 'routes/leads/leads.html'
    controller: 'LeadsCtrl'
    params:
      roleType: 'Selling'
      booked: null
    data:
      title: 'Selling'
      auth: ['superadmin', 'admin', 'agency']
  $stateProvider.state 'letting',
    url: '/letting'
    templateUrl: 'routes/leads/leads.html'
    controller: 'LeadsCtrl'
    params:
      roleType: 'Letting'
      booked: null
    data:
      title: 'Letting'
      auth: ['superadmin', 'admin', 'agency']
  $stateProvider.state 'valuation',
    url: '/valuation'
    templateUrl: 'routes/leads/leads.html'
    controller: 'LeadsCtrl'
    params:
      roleType: 'Valuation'
      booked: null
    data:
      title: 'Letting'
      auth: ['superadmin', 'admin', 'agency']