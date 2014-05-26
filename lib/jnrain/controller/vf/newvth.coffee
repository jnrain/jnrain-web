define [
  'angular'

  'jnrain/api/ds'
  'jnrain/ui/toasts'
  'angular-ui-router'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vf/newvth', [
    'ui.router'
    'jnrain/api/ds'
    'jnrain/ui/toasts'
  ]

  mod.controller 'NewVFileWithVThread',
    ($scope, $rootScope, $state, $timeout, $log, DSAPI, Toasts) ->
      $log = $log.getInstance 'NewVFileWithVThread'

      # XXX kludge
      resolvedData = $state.$current.locals.globals
      vtpid = resolvedData.vtpid
      vtagid = resolvedData.vtagid
      vtagInfo = resolvedData.vtagInfo

      $scope.requestInProgress = false

      doCreateSuccessRedirect = () ->
        # 虚标签详情页
        $state.go 'vtp.vtag.content'

      $scope.vfCreatCallback = (retcode, vfid, vthid) ->
        $scope.requestInProgress = false

        if retcode == 0
          $log.info 'vf creat OK: vfid=', vfid, ', vthid=', vthid
        else
          $log.warn 'vf creat failed; retcode=', retcode

          Toasts.toast(
            'warn',
            '发表话题失败',
            '您的话题未能成功发表，错误码：' + retcode,
          )

          return

        Toasts.toast(
          'info',
          '发表话题成功',
          '您的话题已发表。',
        )

        # 提前请求虚标签详情视图刷新虚线索列表
        $rootScope.$broadcast 'vtag:requestRefresh', vtpid, vtagid

        # 2 秒后返回虚标签详情页
        $timeout doCreateSuccessRedirect, 2000

      $scope.doCreateVFile = () ->
        title = $scope.title
        content = $scope.content

        $scope.requestInProgress = true
        DSAPI.vfile.creat(
          content,
          title,
          null,  # vthid
          vtpid,
          [vtagid],
          null,
          $scope.vfCreatCallback,
        )

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'vtp.vtag.newvth',
      url: '/post'
      resolve:
        navData: () ->
          title: '发表一个话题'
      views:
        main:
          templateUrl: 'vf/newvth.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
