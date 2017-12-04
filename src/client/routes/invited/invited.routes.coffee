'use strict'

angular.module 'vs-leads'
.config ($stateProvider) ->
  $stateProvider.state 'invited',
    url: '/invited'
    templateUrl: 'routes/invited/invited.html'
    controller: 'InvitedCtrl'