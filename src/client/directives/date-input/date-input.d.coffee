'use strict'

angular.module 'ndx'
.directive 'dateInput', ($filter, $timeout) ->
  require: 'ngModel'
  scope:
    ngModel: '='
  link: (scope, elem, attrs, ctrl) ->
    date = null
    ctrl.$parsers.push (val) ->
      date = interpretDate.interpretText val
      if date
        date.setHours(9)
        date.setMinutes(0)
        date.setSeconds(0)
        date.setMilliseconds(0)
        date.valueOf()
        ctrl.$setValidity 'date', true
      else
        if val
          ctrl.$setValidity 'date', false
      val
    ctrl.$formatters.push (val) ->
      if Object.prototype.toString.call(val) is '[object Number]'
        date = new Date(val)
      if val and date
        if attrs.min
          ctrl.$setValidity 'min', date.valueOf() >= +attrs.min
        if attrs.max
          ctrl.$setValidity 'max', date.valueOf() <= +attrs.max
        ctrl.$setValidity 'date', true
      else
        ctrl.$setValidity 'min', true
        ctrl.$setValidity 'max', true
        ctrl.$setValidity 'date', true
      $filter('date')(val, scope.$root.mediumDate)
    blur = ->
      $timeout ->
        if date
          date.setHours(9)
          date.setMinutes(0)
          date.setSeconds(0)
          date.setMilliseconds(0)
          scope.ngModel = date.valueOf()
        else
          scope.ngModel = null
        ctrl.$render()
    elem[0].addEventListener 'blur', blur
    scope.$on '$destroy', ->
      elem[0].removeEventListener 'blur', blur