define [
  'angular'
  'lodash'

  'jnrain/provider/vpool'
], (angular, _) ->
  'use strict'

  (app) ->
    # 顶部导航
    app.controller 'NavHeader', [
      '$scope'
      'VPool'
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
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
