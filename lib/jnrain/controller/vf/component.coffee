define [
  'angular'

  'jnrain/provider/vfile'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vf/component', [
    'jnrain/provider/vfile'
  ]

  # 虚文件组件
  mod.controller 'VFileComponent',
    ($scope, $log, VFile) ->
      $log = $log.getInstance 'VFileComponent'

      vfid = null
      isRoot = false
      replies = []

      doRefreshView = () ->
        VFile.maybeRefresh vfid, null

      $scope.$on 'provider:vf:updated', (evt, vfidUpdated, data) ->
        if vfid != vfidUpdated
          return

        $log.info 'vfid=', vfid, ': data updated: ', data

      $scope.$watch 'vfid', (to, from) ->
        if to?
          vfid = to
          $log.debug 'vfid set to ', vfid

          # 触发数据刷新
          doRefreshView()

      $scope.$watch 'isRoot', (to, from) ->
        isRoot = !!to
        $log.debug 'isRoot set to ', isRoot

      $scope.$watch 'replies', (to, from) ->
        if to?
          replies = to
          $log.debug 'replies set to ', replies

      $log.debug '$scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
