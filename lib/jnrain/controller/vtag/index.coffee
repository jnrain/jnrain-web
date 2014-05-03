define [
  'angular'
  'angular-ui-router'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vtag/index', [
    'ui.router'
  ]

  mod.controller 'VTagIndexPage',
    ($scope, $state, $log) ->
      $log = $log.getInstance 'VTagIndexPage'

      # XXX kludge... 应该如何解决? 直接在状态定义里指定 controller 貌似会
      # 造成 controller 不初始化, 原因不明...
      vtagInfo = $state.$current.locals.globals.vtagInfo
      $scope.vtagInfo = vtagInfo

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'vtp.vtag',
      url: '/t/:vtagid'
      resolve:
        vtagInfo: [
          '$stateParams'
          'VPool'
          ($stateParams, VPool) ->
            vtpData = VPool.getVPoolData $stateParams.vtpid
            vtags = vtpData.vtags
            vtags[$stateParams.vtagid]
        ]
        navData: [
          'vtagInfo'
          (vtagInfo) ->
            title: vtagInfo.name
            root: true
        ]
      views:
        main:
          templateUrl: 'vtag/index.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
