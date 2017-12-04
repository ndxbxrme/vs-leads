'use strict'

angular.module 'vs-leads'
.directive 'footer', ->
  restrict: 'EA'
  templateUrl: 'directives/footer/footer.html'
  replace: true
  link: (scope, elem, attrs) ->
    console.log 'footer directive'