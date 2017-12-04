'use strict'

angular.module 'vs-leads', [
  'ndx'
  'ui.router'
  'ng-sumoselect'
  'ui.gravatar'
]
.config ($locationProvider, $urlRouterProvider, gravatarServiceProvider) ->
  $urlRouterProvider.otherwise '/'
  $locationProvider.html5Mode true
  gravatarServiceProvider.defaults =
    size: 16
    "default": 'mm'
    rating: 'pg'
.run ($http, env) ->
  $http.defaults.headers.common.Authorization = "Bearer #{env.PROPERTY_TOKEN}"
try
  angular.module 'ndx'
catch e
  angular.module 'ndx', [] #ndx module stub