'use strict'

angular.module 'vs-leads', [
  'ndx'
  'ui.router'
  'ng-sumoselect'
  'ui.gravatar'
]
.config ($locationProvider, $urlRouterProvider, gravatarServiceProvider, $httpProvider, AuthProvider) ->
  $urlRouterProvider.otherwise '/'
  $locationProvider.html5Mode true
  gravatarServiceProvider.defaults =
    size: 16
    "default": 'mm'
    rating: 'pg'
.run ($http, env, $rootScope, $state) ->
  $http.defaults.headers.common.Authorization = "Bearer #{env.PROPERTY_TOKEN}"
  $rootScope.state = (route) ->
    if $state and $state.current
      if Object.prototype.toString.call(route) is '[object Array]'
        return route.indexOf($state.current.name) isnt -1
      else
        return route is $state.current.name
    false
try
  angular.module 'ndx'
catch e
  angular.module 'ndx', [] #ndx module stub