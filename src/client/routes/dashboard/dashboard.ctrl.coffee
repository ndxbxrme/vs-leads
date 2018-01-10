'use strict'

angular.module 'vs-leads'
.controller 'DashboardCtrl', ($scope) ->
  $scope.auth.onUser ->
    $scope.sellingToday = $scope.list 'leads',
      preRefresh: (args) ->
        end = new Date()
        start = new Date(new Date().setDate(end.getDate() - 1))
        args.where =
          date:
            $gte: start.valueOf()
            $lte: end.valueOf()
          roleType: 'Selling'
      page: 1
      pageSize: 0
    $scope.sellingOutstanding = $scope.list 'leads',
      preRefresh: (args) ->
        now = new Date()
        end = new Date(new Date().setDate(now.getDate() - 1))
        args.where =
          date:
            $lte: end.valueOf()
          roleType: 'Selling'
          booked: null
      page: 1
      pageSize: 0
    $scope.lettingToday = $scope.list 'leads',
      preRefresh: (args) ->
        end = new Date()
        start = new Date(new Date().setDate(end.getDate() - 1))
        args.where =
          date:
            $gte: start.valueOf()
            $lte: end.valueOf()
          roleType: 'Letting'
      page: 1
      pageSize: 0
    $scope.lettingOutstanding = $scope.list 'leads',
      preRefresh: (args) ->
        now = new Date()
        end = new Date(new Date().setDate(now.getDate() - 1))
        args.where =
          date:
            $lte: end.valueOf()
          roleType: 'Letting'
          booked: null
      page: 1
      pageSize: 0
    $scope.valuationToday = $scope.list 'leads',
      preRefresh: (args) ->
        end = new Date()
        start = new Date(new Date().setDate(end.getDate() - 1))
        args.where =
          date:
            $gte: start.valueOf()
            $lte: end.valueOf()
          roleType: 'Valuation'
      page: 1
      pageSize: 0
    $scope.valuationOutstanding = $scope.list 'leads',
      preRefresh: (args) ->
        now = new Date()
        end = new Date(new Date().setDate(now.getDate() - 1))
        args.where =
          date:
            $lte: end.valueOf()
          roleType: 'Valuation'
          booked: null
      page: 1
      pageSize: 0