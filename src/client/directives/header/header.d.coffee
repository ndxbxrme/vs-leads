'use strict'

angular.module 'vs-leads'
.directive 'header', ($rootScope) ->
  restrict: 'EA'
  templateUrl: 'directives/header/header.html'
  replace: true
  link: (scope, elem, attrs) ->
    scope.toggleMobileMenu = ($event) ->
      $rootScope.mobileMenuOut = not $rootScope.mobileMenuOut
      $event.stopPropagation()