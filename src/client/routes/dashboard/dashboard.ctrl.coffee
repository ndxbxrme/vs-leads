'use strict'

angular.module 'vs-leads'
.controller 'DashboardCtrl', ($scope) ->
  $scope.sellingToday = $scope.list 'leads',
    preRefresh: (args) ->
      console.log 'preRefresh'
      end = new Date()
      start = new Date(new Date().setDate(end.getDate() - 1))
      args.where =
        date:
          $gte: start
          $lte: end
        roleType: 'Selling'
    page: 1
    pageSize: 0
  $scope.sellingOutstanding = $scope.list 'leads',
    preRefresh: (args) ->
      console.log 'preRefresh'
      now = new Date()
      end = new Date(new Date().setDate(now.getDate() - 1))
      args.where =
        date:
          $lte: end
        roleType: 'Selling'
        booked: null
    page: 1
    pageSize: 0
  $scope.lettingToday = $scope.list 'leads',
    preRefresh: (args) ->
      console.log 'preRefresh'
      end = new Date()
      start = new Date(new Date().setDate(end.getDate() - 1))
      args.where =
        date:
          $gte: start
          $lte: end
        roleType: 'Letting'
    page: 1
    pageSize: 0
  $scope.lettingOutstanding = $scope.list 'leads',
    preRefresh: (args) ->
      console.log 'preRefresh'
      now = new Date()
      end = new Date(new Date().setDate(now.getDate() - 1))
      args.where =
        date:
          $lte: end
        roleType: 'Letting'
        booked: null
    page: 1
    pageSize: 0
  $scope.valuationToday = $scope.list 'leads',
    preRefresh: (args) ->
      console.log 'preRefresh'
      end = new Date()
      start = new Date(new Date().setDate(end.getDate() - 1))
      args.where =
        date:
          $gte: start
          $lte: end
        roleType: 'Valuation'
    page: 1
    pageSize: 0
  $scope.valuationOutstanding = $scope.list 'leads',
    preRefresh: (args) ->
      console.log 'preRefresh'
      now = new Date()
      end = new Date(new Date().setDate(now.getDate() - 1))
      args.where =
        date:
          $lte: end
        roleType: 'Valuation'
        booked: null
    page: 1
    pageSize: 0