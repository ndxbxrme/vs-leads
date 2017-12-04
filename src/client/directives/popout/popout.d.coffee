'use strict'

angular.module 'ndx'
.directive 'popout', ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    $(elem[0]).addClass 'has-popout'
    .on 'click', ->
      elm = $(@).parent().find '.popout'
      if elm.hasClass 'out'
        elm.removeClass 'out'
      else
        elm.addClass 'out'