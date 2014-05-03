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

  # 虚标签列表
  mod.controller 'VTagsOverview',
    ($scope, $log, VPool) ->
      $log = $log.getInstance 'VTagsOverview'

      $scope.GLOBAL_VPOOL = VPool.GLOBAL_VPOOL
      $scope.vtags = {}

      $scope.$on 'provider:vtpDataUpdated', (evt, vtpid, stat, vtags) ->
        if vtpid == VPool.GLOBAL_VPOOL
          $log.info 'global vpool data updated'
          $scope.vtags = vtags

      # 由于 controller 初始化顺序的原因, 这里貌似需要一次重复刷新...
      VPool.maybeRefresh VPool.GLOBAL_VPOOL

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'home',
      url: '/'
      resolve:
        navData: () ->
          title: '首页'
          root: true
      views:
        main:
          templateUrl: 'home.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
