define [
  'angular'
  'angular-ui-router'

  'jnrain/provider/vpool'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/home', [
    'ui.router'
    'jnrain/provider/vpool'
  ]

  # 首页
  mod.controller 'Home',
    ($scope, VPool) ->
      console.log '[Home] $scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'home',
      url: '/'
      controller: 'Home'
      data:
        title: '首页'
      views:
        main:
          templateUrl: 'home.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
