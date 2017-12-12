'use strict'

angular.module 'vs-leads'
.controller 'LeadsCtrl', ($scope, $stateParams, Sorter) ->
  $scope.leads = $scope.list 'leads', 
    where: JSON.parse JSON.stringify $stateParams
    sort: 'date'
    sortDir: 'DESC'
    page: 1
    pageSize: 20
  $scope.allleads = $scope.list 'leads', 
    where: JSON.parse JSON.stringify $stateParams
    page: 1
    pageSize: 0
  $scope.sort = Sorter.create $scope.leads.args
  $scope.roleType = $stateParams.roleType