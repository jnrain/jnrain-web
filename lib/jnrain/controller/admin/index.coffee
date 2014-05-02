define [
  'angular'
  'angular-ui-router'
  'ui-bootstrap'

  'jnrain/provider/vpool'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/admin/index', [
    'ui.router'
    'ui.bootstrap'
    'jnrain/provider/vpool'
  ]

  # 管理视图首页
  mod.controller 'AdminIndex',
    ($scope, $stateParams, $log, VPool) ->
      $log = $log.getInstance 'AdminIndex'

      $scope.GLOBAL_VPOOL = VPool.GLOBAL_VPOOL

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'admin',
      url: '/admin'
      data:
        title: '系统管理面板'
      views:
        main:
          templateUrl: 'admin/index.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
