'use strict'

angular.module 'vs-leads'
.config ($stateProvider) ->
  $stateProvider.state 'invited',
    url: '/invite/:code'
    templateUrl: 'routes/invited/invited.html'
    controller: 'InvitedCtrl'