define [
  'angular'

  'jnrain/provider/vthread'
  'angular-ui-router'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vth/index', [
    'ui.router'
    'jnrain/provider/vthread'
  ]

  mod.controller 'VThreadIndexPage',
    ($scope, $state, $log, VThread) ->
      $log = $log.getInstance 'VThreadIndexPage'

      # XXX: kludge
      resolvedData = $state.$current.locals.globals
      vthid = resolvedData.vthid

      $scope.vthid = vthid
      $scope.vthStat = {}
      $scope.vthRootVFID = null
      $scope.vthReplies = []

      VThread.maybeRefresh vthid, (retcode, data, errorPhase) ->
        if retcode == 0
          $log.info 'vth refreshed:', data
        else
          $log.warn(
            'vth refresh failure: retcode=',
            retcode,
            ', phase=',
            errorPhase,
          )
          return

        $scope.vthStat = data.stat

        tree = data.tree
        $scope.vthRootVFID = tree.shift()
        $scope.vthReplies = tree

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'vtp.vtag.vth',
      # TODO: 支持 URL slug
      url: '/a/:vthid'
      resolve:
        vthid: [
          '$stateParams'
          ($stateParams) ->
            $stateParams.vthid
        ]
        navData: () ->
          # TODO: 注射虚线索元数据于此, 展示对应标题
          title: '阅读主题'
      views:
        main:
          templateUrl: 'vth/index.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
