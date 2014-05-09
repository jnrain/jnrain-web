define [
  'angular'
  'jnrain/util/time'
  'angular-ui-router'
], (angular, TimeUtil) ->
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

      # 指定默认展示虚线索的时间段为当前时间整小时数 + 1, 到该时间点 7 天之前
      # 的内容
      nowInFullHours = TimeUtil.fullHourFromDate new Date()
      timeEnd = $scope.timeEnd = TimeUtil.hoursLater nowInFullHours, 1
      $scope.timeStart = TimeUtil.hoursLater timeEnd, -24 * 7

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
