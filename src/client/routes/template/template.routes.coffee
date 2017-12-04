'use strict'

angular.module 'vs-leads'
.config ($stateProvider) ->
  $stateProvider.state 'template',
    url: '/template/:id/:type'
    templateUrl: 'routes/template/template.html'
    controller: 'TemplateCtrl'
    data:
      title: 'template'
      auth: ['superadmin', 'admin']