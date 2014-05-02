define [
  'angular'
  'lodash'

  'jnrain/provider/vpool'
], (angular, _) ->
  'use strict'

  mod = angular.module 'jnrain/controller/nav/header', [
    'jnrain/provider/vpool'
  ]

  # 顶部导航
  mod.controller 'NavHeader',
    ($scope, $log, VPool) ->
      $log = $log.getInstance 'NavHeader'

      # 这个引用是给模板用的
      $scope.GLOBAL_VPOOL = VPool.GLOBAL_VPOOL
      $scope.vtags = {}
      $scope.numVTags = 0

      $scope.$watch 'vtags', (to, from) ->
        # 更新虚标签数量显示
        $scope.numVTags = Object.keys($scope.vtags).length

      $scope.$on 'provider:vtpDataUpdated', (evt, vtpid, stat, vtags) ->
        if vtpid == VPool.GLOBAL_VPOOL
          $log.info 'global vpool data updated'
          $scope.vtags = vtags

      # 触发一次刷新
      VPool.maybeRefresh(VPool.GLOBAL_VPOOL)

      $log.debug '$scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
