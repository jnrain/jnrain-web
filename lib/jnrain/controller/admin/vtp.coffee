define [
  'angular'
  'angular-route'

  'jnrain/provider/vpool'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/admin/vtp', [
    'ngRoute'
    'jnrain/provider/vpool'
  ]

  # 虚线索池管理视图
  mod.controller 'VTPAdmin',
    ($scope, $routeParams, VPool) ->
      vtpid = $routeParams.vtpid

      $scope.vtpid = vtpid
      $scope.isGlobalVPool = vtpid == VPool.GLOBAL_VPOOL
      $scope.requestInProgress = true
      $scope.retcode = null
      $scope.vtpStat = null
      $scope.vtpVTags = null
      $scope.errorPhase = null

      # 因为是管理界面... 应该请求最新的数据. 这里倒不用考虑太多性能问题,
      # 毕竟用管理界面的人比用户少多了
      VPool.forceRefresh vtpid, (retcode, data, errorPhase) ->
        $scope.requestInProgress = false
        $scope.retcode = retcode
        if retcode != 0
          $scope.errorPhase = errorPhase
        else
          $scope.vtpStat = data.stat
          $scope.vtpVTags = data.vtags

      console.log '[VTPAdmin] $routeParams = ', $routeParams
      console.log '[VTPAdmin] $scope = ', $scope

  mod.config ($routeProvider) ->
    $routeProvider.when '/admin/vtp/:vtpid',
      templateUrl: 'admin/vtp.html'
      controller: 'VTPAdmin'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
