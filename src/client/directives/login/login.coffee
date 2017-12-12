'use strict'

angular.module 'vs-leads'
.directive 'login', ($http, $location, $state) ->
  restrict: 'AE'
  templateUrl: 'directives/login/login.html'
  replace: true
  scope: {}
  link: (scope, elem) ->
    scope.login = ->
      scope.submitted = true
      if not scope.email
        scope.emailerror = true
      if not scope.password
        scope.passworderror = true
      if not scope.emailerror and not scope.passworderror
        $http.post '/api/login',
          email: scope.email
          password: scope.password
        .then (response) ->
          scope.auth.getPromise()
          .then ->
            $state.go 'dashboard'
        , (err) ->
          scope.message = err.data
          scope.submitted = false
    scope.signup = ->
      scope.submitted = true
      if scope.loginForm.$valid
        $http.post '/api/signup',
          email: scope.email
          password: scope.password
        .then (response) ->
          scope.auth.getPromise()
          .then ->
            scope.auth.goToNext()
        , (err) ->
          scope.message = err.data
          scope.submitted = false 