'use strict'

angular.module 'ndx'
.provider 'datePicker', ->
  open = false
  fns = []
  $get: ->
    setOpen: (val) ->
      open = val
    isOpen: ->
      open
    add: (closeFn) ->
      fns.push closeFn
    remove: (closeFn) ->
      fns.splice fns.indexOf(closeFn), 1
    clear: ->
      fns = []
    closeAll: ->
      for fn in fns
        fn()
      fns = []
.directive 'datePicker', ($document, $templateCache, $compile, $timeout, $filter, $window, datePicker) ->
  restrict: 'AE'
  require: 'ngModel'
  template: '<div class="input-holder"><input name="{{name}}" date-input class="date-picker-input" ng-model="ngModel" min="{{min}}" max="{{max}}" ng-required="{{required}}" title="{{placeholder}}" placeholder="{{placeholder}}" ng-blur="change()" /><button ng-click="open()" type="button"><i class="icon calendar"></i></button></div>'
  replace: true
  scope:
    ngModel: '='
    dateFormat: '@'
    anchor: '@'
    placeholder: '@'
    closeOnSelect: '@'
    required: '@'
    name: '@'
    min: '@'
    max: '@'
    change: '='
  link: (scope, elem, attrs, ctrl) ->
    customClasses = elem[0].className.replace(/date-picker-input|ng.*/g, '').trim()
    scope.dateFormat = scope.dateFormat or scope.mediumDate or scope.$root.mediumDate or 'mediumDate'
    scope.mode = 'date'
    scope.toggleMode = ->
      scope.setDate scope.date
      scope.mode = if scope.mode is 'date' then 'year' else 'date'
    me = {}
    me.dFormat = 'YYYY-MM-DD'
    me.today = moment().format(me.dFormat)
    me._buildDayObject = (y, m, d) ->
      _d = moment([
        y
        m
        d
      ])
      {
        num: _d.date()
        date: _d.format(me.dFormat)
        weekday: _d.weekday()
        month: m
      }
    me._calendarData = (date) ->
      _key = moment(date).startOf('month')
      # setup 'current' month days
      d = []
      d = _.times(_key.daysInMonth(), (n) ->
        me._buildDayObject _key.year(), _key.month(), n + 1
      )
      # setup prev month backfill days
      _p = moment(_key).subtract(1, 'month')
      _pd = []
      pd = []
      _pi = 0
      _pj = _p.daysInMonth()
      while _pi < _key.isoWeekday()
        _pd.unshift _pj
        _pi++
        _pj--
      pd = _.times(_pd.length, (i) ->
        me._buildDayObject _p.year(), _p.month(), _pd[i]
      )
      # setup next month postfill days
      _n = moment(_key).add(1, 'month')
      _nsd = 1
      _t = 0
      _nd = []
      nd = []
      _t = d.length + _pd.length
      while _t % 14 != 0
        _nd.push _nsd
        _nsd++
        _t++
      nd = _.times(_nd.length, (i) ->
        me._buildDayObject _n.year(), _n.month(), _nd[i]
      )
      {
        days: pd.concat(d).concat(nd)
        year: _key.year()
        month: _key.month()
        monthName: _key.format('MMMM')
      }
    me._generateMonths = (date) ->
      m = []
      date = if moment(date).isValid() then moment(date).valueOf() else moment().valueOf()
      m.push me._calendarData(moment(date).subtract(1, 'month'))
      m.push me._calendarData(moment(date))
      m.push me._calendarData(moment(date).add(1, 'month'))
      m
    me._tryFuzzyDates = (date) ->
      if date == 'today'
        date = me.today
      else if date == 'tomorrow'
        date = moment(me.today).add(1, 'day')
      else if date == 'yesterday'
        date = moment(me.today).subtract(1, 'day')
      date
    modifier = 2.5
    swiper = null
    carousel = null
    hammerSwiper = null
    swiperBox = null
    original = null
    d = undefined
    x = 0
    y = 0
    scope.mod = 4
    _snaps = [
      {
        key: 0
        value: 0
      }
      {
        key: 1
        value: -100
      }
      {
        key: 2
        value: -200
      }
    ]
    if head.mobile
      scope.mod = 1.4
    # get the snap location at 'panend' for where to animate the carousel
    _calculateSnapPoint = (pos) ->
      diff = undefined
      # difference between pos and snap value
      min = undefined
      # smallest difference
      key = undefined
      # best snap key
      value = undefined
      # best snap value
      # loop to find smallest diff, it is closest to the pos
      snapVal = -100
      #if head.browser.ie
      #  snapVal = -33.3333
      _.times 3, (n) ->
        snap = if n > 0 then n * snapVal else 0
        diff = Math.abs(pos - snap)
        if _.isUndefined(min) or diff < min
          min = diff
          key = n
          value = snap
        return
      {
        key: key
        value: value
      }
    yearPointer = null
    noYears = 15
    generateYears = ->
      startYear = yearPointer - Math.floor(noYears/2) - noYears
      for month in scope.months
        month.years = []
        i = 0
        while i++ < noYears
          month.years.push startYear++
        
    _setMonths = (snap) ->
      _c = scope.months[snap.key]
      carousel.removeClass('dragging').addClass('animate').css transform: 'translate3d(' + snap.value + '%, 0, 0)'
      # center active date, regenerate calendars
      if snap.key != 1
        $timeout (->
          scope.months = me._generateMonths(moment([
            _c.year
            _c.month
          ]).valueOf())
          if scope.mode is 'year'
            if snap.key is 0
              yearPointer -= noYears
            else if snap.key is 2
              yearPointer += noYears
          generateYears()
          scope.snap = _snaps[1]
          carousel.removeClass('animate').css transform: 'translate3d(' + scope.snap.value + '%, 0, 0)'
          return
        ), 300
      return
    getOffset = (elm) ->
      offset =
        left: 0
        top: 0
      while elm and elm.tagName isnt 'BODY'
        if elm.style.position isnt 'fixed'
          offset.left += elm.offsetLeft
          offset.top += elm.offsetTop
        else
          offset.left += elm.offsetLeft - (elm.clientWidth / 2)
          offset.top += elm.offsetTop
        elm = elm.offsetParent
      offset
    scope.setDate = (date, isTap) ->
      scope.date = me._setActiveDate(date)
      yearPointer = new Date(scope.date).getFullYear()
      scope.months = me._generateMonths(scope.date)
      generateYears()
      _setMonths scope.snap
      scope.ngModel = new Date(scope.date).valueOf()
      setValidity()
      if isTap and scope.closeOnSelect
        scope.done()
      return
    scope.setYear = (year) ->
      if new Date(scope.date).getFullYear() isnt year
        scope.date = "#{year}-01-01"
      scope.setDate scope.date
      scope.mode = 'date'
    # Calculate the classes for the calendar items.
    scope.setClass = (day, month) ->
      classes = []
      if day.date == scope.date
        classes.push 'is-selected'
      if day.date == me.today
        classes.push 'is-today'
      if day.weekday == 0 or day.weekday == 6
        classes.push 'is-weekend'
      if day.month == month.month
        classes.push 'day-in-curr-month'
      date = new Date day.date
      date = new Date date.getFullYear(), date.getMonth(), date.getDate()
      date.setHours(9)
      if attrs.min
        if /^\d+$/.test attrs.min
          attrs.min = +attrs.min
        min = new Date attrs.min
        min.setHours(0)
        if date.valueOf() < min.valueOf()
          classes.push 'invalid'
          classes.push 'before'
      if attrs.max
        if /^\d+$/.test attrs.max
          attrs.max = +attrs.max
        max = new Date attrs.max
        date.setHours(0)
        if date.valueOf() > max.valueOf()
          classes.push 'invalid'
          classes.push 'after'
      classes.join ' '
    scope.monthPrev = ->
      scope.snap =
        key: 0
        value: 0
      _setMonths scope.snap
    scope.monthNext = ->
      scope.snap = _snaps[2]
      _setMonths scope.snap
    setValidity = ->
      if scope.ngModel is original
        return
      date = new Date +scope.ngModel
      date = new Date date.getFullYear(), date.getMonth(), date.getDate()
      date.setHours 9
      if attrs.min
        if /^\d+$/.test attrs.min
          attrs.min = +attrs.min
        min = new Date attrs.min
        ctrl.$setValidity 'min', date.valueOf() >= min.valueOf()
      if attrs.max
        if /^\d+$/.test attrs.max
          attrs.max = +attrs.max
        max = new Date attrs.max
        ctrl.$setValidity 'max', date.valueOf() <= max.valueOf()
    init = (date) ->
      # HAMMER TIME
      hammerSwiper.get('pan').set
        direction: Hammer.DIRECTION_ALL
        threshold: 0
      hammerSwiper.on('panstart', ->
        carousel.addClass('dragging').removeClass 'animate'
        swiper.addClass 'dragging'
        return
      ).on('panleft panright panup pandown', (e) ->
        d = if Math.abs(parseInt(e.deltaX)) > Math.abs(parseInt(e.deltaY)) then 'x' else 'y'
        x = scope.snap.value + parseInt(e.deltaX) / el[0].clientWidth * 100 * scope.mod
        y = parseInt(e.deltaY) / el[0].clientHeight * 100 * scope.mod
        y = if y < 0 then 0 else y
        if d == 'x'
          carousel.css transform: 'translate3d(' + x + '%, 0, 0)'
        ###
        else
          swiper.css transform: 'translate3d(0, ' + y + '%, 0)'
        ###
        return
      ).on 'panend', ->
        swiper.removeClass('dragging').css transform: ''
        if d == 'x'
          scope.snap = _calculateSnapPoint(x)
          _setMonths scope.snap
        ###
        if d == 'y' and y > 35
          scope.toggle()
        ###
        scope.$apply()
        return
      scope.dayNames = [
        'Sun'
        'Mon'
        'Tue'
        'Wed'
        'Thu'
        'Fri'
        'Sat'
      ]
      scope.snap = _snaps[1]
      scope.setDate date
      original = scope.ngModel
      return
    me._setActiveDate = (date) ->
      date = me._tryFuzzyDates(date)
      if moment(date).isValid() then moment(date).format(me.dFormat) else null
    body = $document.find('body').eq 0
    el = null
    setPos = ->
      offset = getOffset(elem[0])
      height = elem[0].offsetHeight
      scrollTop = body[0].scrollTop or document.documentElement.scrollTop
      scrollLeft = body[0].scrollLeft or document.documentElement.scrollLeft
      newTop = ((offset.top + height) - scrollTop)
      if newTop + swiperBox[0].offsetHeight > $window.innerHeight
        newTop = $window.innerHeight - swiperBox[0].offsetHeight
      if newTop < 0
        newTop = 0
      newLeft = ((offset.left) - scrollLeft)
      if newLeft + swiperBox[0].offsetWidth > $window.innerWidth
        newLeft = $window.innerWidth - swiperBox[0].offsetWidth
      if newLeft < 0
        newLeft = 0
      swiperBox[0].style.position = 'absolute'
      swiperBox[0].style.top = newTop + 'px'
      swiperBox[0].style.left = newLeft + 'px'
    keyDown = (ev) ->
      offset = 0
      switch ev.keyCode
        when 39
          offset = 1
        when 37
          offset = -1
        when 38
          offset = -7
        when 40
          offset = 7
        when 13, 32, 27
          ev.preventDefault()
          return scope.done()
      date = new Date scope.date
      newDate = new Date date.getFullYear(), date.getMonth(), date.getDate() + offset
      $timeout ->
        scope.setDate newDate
      ev.preventDefault()
    scope.open = ->
      if datePicker.isOpen()
        return
      datePicker.setOpen true
      el = angular.element $templateCache.get 'directives/date-picker/date-picker.html'
      com = $compile(el) scope
      body.append com
      el.addClass customClasses
      swiper = el
      carousel = angular.element(el[0].querySelector('.carousel'))
      swiperBox = angular.element(el[0].querySelector('.date-picker-box'))
      $('.done', el[0]).focus()
      hammerSwiper = new Hammer(swiper[0])
      d = undefined
      x = 0
      y = 0
      init scope.ngModel
      if scope.anchor

        setPos()
        el.addClass 'open'

        $window.addEventListener 'scroll', setPos
        $window.addEventListener 'resize', setPos
      $window.addEventListener 'keydown', keyDown
    scope.$on '$destroy', ->
      scope.done 0
    scope.done = (time) ->
      ctrl.$setDirty()
      if el
        d = new Date(scope.date)
        d.setHours(9)
        d.setMinutes(0)
        d.setSeconds(0)
        d.setMilliseconds(0)
        scope.ngModel = d.valueOf()
        setValidity()
        el.addClass 'closing'
        $timeout ->
          datePicker.setOpen false
          el.remove()
          hammerSwiper = null
        , if angular.isDefined(time) then time else 200
      if scope.anchor
        $window.removeEventListener 'scroll', setPos
        $window.removeEventListener 'resize', setPos
      $window.removeEventListener 'keydown', keyDown
      scope.change?()