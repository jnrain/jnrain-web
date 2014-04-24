define [
  'angular'
  'lodash'

  'jnrain/provider/vpool'
], (angular, _) ->
  (app) ->
    # 顶部导航
    app.controller 'NavHeader', [
      '$scope'
      'VPool'
      ($scope, VPool) ->
        VPool.maybeRefresh VPool.GLOBAL_VPOOL, (retcode, vtpData, errorPhase) ->
          if retcode == 0
            console.log '[NavHeader] global vpool refresh: OK, vtpData=', vtpData
          else
            console.log '[NavHeader] global vpool refresh: errored, retcode=', retcode, ' errorPhase=', errorPhase

        console.log '[NavHeader] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
