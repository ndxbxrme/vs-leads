'use strict'

angular.module 'vs-leads'
.directive 'header', ->
  restrict: 'EA'
  templateUrl: 'directives/header/header.html'
  replace: true
  link: (scope, elem, attrs) ->
    true