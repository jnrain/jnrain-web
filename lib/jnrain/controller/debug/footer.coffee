define [
  'angular'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/debug/footer', [
  ]

  # footer 调试信息
  mod.controller 'DebugFooter',
    ($scope) ->
      # 后端版本
      $scope.versions =
        weiyu: 'unknown'
        luohua: 'unknown'

      # 从实时信道组件接收后端版本的更新
      $scope.$on 'api:backendVersionsObtained', (evt, versions) ->
        console.log '[DebugFooter] obtained backend versions: ', versions
        $scope.versions = versions

      console.log '[DebugFooter] $scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
