'use strict'

angular.module 'vs-leads'
.controller 'HistoryCtrl', ($scope, $http, Sorter) ->
  where =
    $or:
      deleted:
        $nn: true
      booked:
        $nn: true
    roleType: 'Selling'
  $scope.history = $scope.list 'leads',
    where: where
    pageSize: 25
    page: 1
    sort: 'date'
    sortDir: 'DESC'
  $scope.allhistory = $scope.list 'leads',
    where: where
    page: 1
    pageSize: 0
  $scope.sort = Sorter.create $scope.history.args
  $scope.restore = (lead) ->
    $http.post "/api/leads/#{lead._id}",
      deleted: null
      booked: null