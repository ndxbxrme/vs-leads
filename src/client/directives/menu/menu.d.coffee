'use strict'

angular.module 'vs-leads'
.directive 'menu', ->
  restrict: 'EA'
  templateUrl: 'directives/menu/menu.html'
  replace: true
  link: (scope, elem, attrs) ->
    true