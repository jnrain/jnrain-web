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
    ($scope, VPool) ->
      # 这个引用是给模板用的
      $scope.GLOBAL_VPOOL = VPool.GLOBAL_VPOOL

      VPool.maybeRefresh(
        VPool.GLOBAL_VPOOL,
        (retcode, vtpData, errorPhase) ->
          if retcode == 0
            console.log(
              '[NavHeader] global vpool refresh: OK, vtpData=',
              vtpData,
            )
            $scope.vtags = vtpData.vtags
          else
            console.log(
              '[NavHeader] global vpool refresh: errored, retcode=',
              retcode,
              ' errorPhase=',
              errorPhase,
            )
      )

      console.log '[NavHeader] $scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
