define [
  'angular'

  'jnrain/util/time'
  'jnrain/api/ds'
  'angular-ui-router'
], (angular, TimeUtil) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vtag/index', [
    'ui.router'
    'jnrain/api/ds'
  ]

  mod.controller 'VTagIndexPage',
    ($scope, $state, $log, DSAPI) ->
      $log = $log.getInstance 'VTagIndexPage'

      # XXX kludge... 应该如何解决? 直接在状态定义里指定 controller 貌似会
      # 造成 controller 不初始化, 原因不明...
      resolvedData = $state.$current.locals.globals
      vtpid = resolvedData.vtpid
      vtagid = resolvedData.vtagid
      vtagInfo = resolvedData.vtagInfo

      $scope.vtagInfo = vtagInfo
      $scope.vthList = []

      # 指定默认展示虚线索的时间段为当前时间整小时数 + 1, 到该时间点 7 天之前
      # 的内容
      nowInFullHours = TimeUtil.fullHourFromDate new Date()
      timeEnd = $scope.timeEnd = TimeUtil.hoursLater nowInFullHours, 1
      $scope.timeStart = TimeUtil.hoursLater timeEnd, -24 * 7

      # 虚线索列表刷新响应回调
      vthListCallback = (retcode, data) ->
        if retcode != 0
          $log.warn 'vth list retrieval failed: retcode=', retcode
          $scope.vthList = []
          return

        $log.info 'vth list retrieved: ', data
        $scope.vthList = data

      # 进行虚线索列表刷新请求
      $scope.refreshVThreadList = () ->
        # TODO: 把这里对 DSAPI 的直接调用封装进一个 provider
        timeStart = $scope.timeStart
        timeEnd = $scope.timeEnd
        DSAPI.vtag.readdir vtpid, vtagid, timeStart, timeEnd, vthListCallback

      $scope.refreshVThreadList()

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'vtp.vtag',
      # TODO: 支持 URL slug
      url: '/t/:vtagid'
      resolve:
        vtagid: [
          '$stateParams'
          ($stateParams) ->
            $stateParams.vtagid
        ]
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
      abstract: true
      views:
        main:
          templateUrl: 'vtag/index.html'

    $stateProvider.state 'vtp.vtag.content',
      url: ''
      resolve:
        navData: () ->
          omit: true
      views:
        main:
          templateUrl: 'vtag/content.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
