define [
  'angular'

  'angular-markdown-directive'

  'jnrain/provider/vfile'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vf/read', [
    'jnrain/provider/vfile'
    'btford.markdown'
  ]

  # 虚文件详情组件
  mod.controller 'VFileReadComponent',
    ($scope, $log, VFile) ->
      $log = $log.getInstance 'VFileReadComponent'

      $scope.vfData = null

      doRefreshView = () ->
        VFile.maybeRefresh $scope.vfid, null

      $scope.$on 'provider:vf:updated', (evt, vfidUpdated, data) ->
        if $scope.vfid != vfidUpdated
          return

        $log.info 'vfid=', $scope.vfid, ': data updated: ', data

        $scope.vfData = data

      $scope.$watch 'vfid', (to, from) ->
        if to?
          $log.debug 'vfid set to ', to

          # 触发数据刷新
          doRefreshView()

      $scope.$watch 'isRoot', (to, from) ->
        $log.debug 'isRoot set to ', to

      $scope.$watch 'replies', (to, from) ->
        if to?
          $log.debug 'replies set to ', to

          # TODO: 刷新楼中楼回复数据

      $log.debug '$scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
