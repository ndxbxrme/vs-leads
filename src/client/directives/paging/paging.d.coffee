'use strict'

angular.module 'ndx'
.directive 'paging', ->
  restrict: 'EA'
  templateUrl: 'directives/paging/paging.html'
  replace: true
  scope:
    total: '='
    opts: '='
  link: (scope, elem, attrs) ->
    true