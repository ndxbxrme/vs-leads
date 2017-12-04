'use strict'

angular.module 'vs-leads'
.config ($stateProvider) ->
  $stateProvider.state 'setup',
    url: '/setup'
    templateUrl: 'routes/setup/setup.html'
    controller: 'SetupCtrl'
    data:
      title: 'setup'
      auth: ['superadmin', 'admin']