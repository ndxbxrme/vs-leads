'use strict'

angular.module 'vs-leads'
.controller 'LeadCtrl', ($scope, $stateParams, env, Auth, Confirmer) ->
  $scope.selectedProperty = null
  $scope.lead = $scope.single 'leads', $stateParams, (lead) ->
    if JSON.stringify(lead.item) is '{}'
      $scope.editing = true
      lead.item =
        roleType: 'Selling'
        source: 'local'
  $scope.sources =
    items: [
      name: 'Email'
      _id: 'email'
    ,
      name: 'Telephone'
      _id: 'telephone'
    ,
      name: 'Walk In'
      _id: 'walkin'
    ,
      name: 'OnTheMarket'
      _id: 'onthemarket'
    ]
  $scope.selling = $scope.list
    route: "#{env.PROPERTY_URL}/search"
  ,
    where:
      RoleType: 'Selling'
      IncludeStc: true
    transform:
      items: 'Collection'
      total: 'TotalCount'
  , (properties) ->
    for property in properties.items
      property.name = property.displayAddress
      property._id = property.RoleId
  $scope.letting = $scope.list
    route: "#{env.PROPERTY_URL}/search"
  ,
    where:
      RoleType: 'Letting'
      IncludeStc: true
    transform:
      items: 'Collection'
      total: 'TotalCount'
  , (properties) ->
    for property in properties.items
      property.name = property.displayAddress
      property._id = property.RoleId
  $scope.deleteLead = ->
    Confirmer.confirm
      title: $scope.m('lead-delete-title')
      message: $scope.m('lead-delete-message')
    .then ->
      $scope.lead.delete()
      $scope.auth.goToLast()
    , ->
      false
  $scope.bookLead = ->
    $scope.lead.item.booked = true
    $scope.lead.save()
    $scope.auth.goToLast()
  $scope.addNote = ->
    if not $scope.lead.item.notes
      $scope.lead.item.notes = []
    if $scope.note
      if $scope.note.date
        for note in $scope.lead.item.notes
          if note.date is $scope.note.date
            note.text = $scope.note.text
            note.updatedAd = new Date()
            note.updatedBy = Auth.getUser()
      else
        $scope.lead.item.notes.push
          date: new Date()
          text: $scope.note.text
          user: Auth.getUser()
      if $scope.lead.item._id
        $scope.lead.save()
      #alert.log 'Note added'
      $scope.note = null
  $scope.editNote = (note) ->
    $scope.note = JSON.parse JSON.stringify note
    $('.add-note')[0].scrollIntoView true
  $scope.getNotes = ->
    if $scope.lead and $scope.lead.item and $scope.lead.item.notes
      $scope.lead.item.notes
  $scope.deleteNote = (note) ->
    for mynote in $scope.lead.item.notes
      if mynote.date is note.date
        $scope.lead.item.notes.remove mynote
    if $scope.lead.item._id
      $scope.lead.save()
  $scope.saveFn = (cb) ->
    if $scope.selectedProperty and $scope.lead.item.roleType isnt 'Valuation'
      for property in $scope[$scope.lead.item.roleType.toLowerCase()].items
        if property._id.toString() is $scope.selectedProperty
          console.log property
          $scope.lead.item.roleId = property.RoleId
          $scope.lead.item.propertyId = property.PropertyId
          $scope.lead.item.price = property.Price.PriceValue
          $scope.lead.item.date = new Date()
          $scope.lead.item.property =
            address: "#{property.Address.Number or property.Address.BuildingName} #{property.Address.Street}"
            address2: "#{property.Address.Locality}"
            town: property.Address.Town
            county: property.Address.County
            postcode: property.Address.Postcode     
          break
    cb true