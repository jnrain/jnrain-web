define [
  'angular'
  'angular-ui-router'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/debug/footer', [
    'ui.router'
  ]

  # footer 调试信息
  mod.controller 'DebugFooter',
    ($scope, $state, $stateParams, $location, $log) ->
      $log = $log.getInstance 'DebugFooter'

      # 单页应用路由
      $scope.$state = $state
      $scope.$location = $location
      $scope.$stateParams = $stateParams

      # 后端版本
      $scope.versions =
        weiyu: 'unknown'
        luohua: 'unknown'

      # 从实时信道组件接收后端版本的更新
      $scope.$on 'api:backendVersionsObtained', (evt, versions) ->
        $log.debug 'obtained backend versions: ', versions
        $scope.versions = versions

      $log.debug '$scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
