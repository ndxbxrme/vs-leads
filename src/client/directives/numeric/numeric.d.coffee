'use strict'

angular.module 'ndx'
.directive 'numeric', ($timeout, $filter, $window) ->
  restrict: 'EA'
  templateUrl: 'directives/numeric/numeric.html'
  require: 'ngModel'
  replace: true
  scope:
    ngModel: '='
    ngChange: '&'
    placeholder: '@'
    tab: '@'
    numDisabled: '='
  link: (scope, elem, attrs, ctrl) ->
    ua = $window.navigator.userAgent
    iPhone = /iphone/i.test ua
    chrome = /chrome/i.test ua
    android = /android/i.test ua
    step = 1
    decimalPoints = 0
    if angular.isDefined attrs.step
      step = +attrs.step
    else if angular.isDefined attrs.decimal
      step = Math.pow 10, -attrs.decimal
    if attrs.scroll
      angular.element(elem).find('input').bind 'mousewheel DOMMouseScroll', (event) ->
        if $(event.target).is(":focus")
          delta = event.originalEvent.deltaY or (event.originalEvent.wheelDelta * -1)
          event.preventDefault()
          if delta < 0
            $timeout ->
              scope.up()
          else
            $timeout ->
              scope.down()
    angular.element(elem).find('input').bind 'blur', ->
      $timeout ->
        if scope.ngModel
          checkBounds scope.ngModel
          scope.ngModel = $filter('number') +scope.ngModel.toString().replace(',',''), attrs.decimal or 0
        if not scope.ngModel and attrs.default
          scope.ngModel = attrs.default
    $timeout ->
      if scope.ngModel
        scope.ngModel = $filter('number') +scope.ngModel.toString().replace(',',''), attrs.decimal or 0
      if not scope.ngModel and attrs.default
        scope.ngModel = attrs.default
    scope.up = ->
      if not scope.ngModel then scope.ngModel = '0'
      scope.ngModel = $filter('number') +scope.ngModel.toString().replace(',','') + step, attrs.decimal or 0
      checkBounds scope.ngModel
    scope.down = ->
      if not scope.ngModel then scope.ngModel = '0'
      scope.ngModel = $filter('number') +scope.ngModel.toString().replace(',','') - step, attrs.decimal or 0
      checkBounds scope.ngModel
    checkBounds = (val, clear) ->
      if val
        val = val.toString().replace(',','')
        if (angular.isDefined(attrs.max) and attrs.max) or attrs.max is 0
          if +val >= +attrs.max
            scope.ngModel = $filter('number') attrs.max
            scope.ngModel = if clear then '' else scope.ngModel
        if (angular.isDefined(attrs.min) and attrs.min) or attrs.min is 0
          if +val < +attrs.min
            scope.ngModel = $filter('number') attrs.min
            scope.ngModel = if clear then '' else scope.ngModel
    setValidity = (val) ->
      if val
        val = val.toString().replace(',','')
        if (angular.isDefined(attrs.max) and attrs.max) or attrs.max is 0
          if +val > +attrs.max
            ctrl.$setValidity 'max', false
          else
            ctrl.$setValidity 'max', true
        if (angular.isDefined(attrs.min) and attrs.min) or attrs.min is 0
          if +val < +attrs.min
            ctrl.$setValidity 'min', false
          else
            ctrl.$setValidity 'min', true
    scope.$watch ->
      attrs.min + attrs.max
    , ->
      setValidity scope.ngModel
    ctrl.$formatters.unshift (val) ->
      setValidity val
      scope.ngChange?()
      val
    #mask
    pattern = /[^\d-\.]/g
    if attrs.min is '0'
      pattern = /[^\d\.]/g
    checkPattern = (key) ->
      text = (scope.ngModel or '') + key
      not pattern.test text
    keyDown = (event) ->
      if event.key.length isnt 1 or event.altKey or event.ctrlKey
        return
      if not checkPattern event.key
        event.preventDefault()
    androidDown = ->
      $timeout ->
        while not checkPattern ''
          scope.ngModel = scope.ngModel.substr(0, scope.ngModel.length - 1)
    if android
      elem.on 'keyup', androidDown
    else
      elem.on 'keydown', keyDown
    scope.$on '$destroy', ->
      if android
        elem.off 'keyup', androidDown
      else
        elem.off 'keydown', keyDown