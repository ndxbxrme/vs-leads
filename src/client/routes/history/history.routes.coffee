'use strict'

angular.module 'vs-leads'
.config ($stateProvider) ->
  $stateProvider.state 'history',
    url: '/history'
    templateUrl: 'routes/history/history.html'
    controller: 'HistoryCtrl'
    data:
      title: 'history'
      auth: ['superadmin', 'admin']