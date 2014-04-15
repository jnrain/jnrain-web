define ['angular', 'jnrain/api/bridge'], (angular) ->
  (app) ->
    # footer 调试信息
    app.controller 'DebugFooter', ['$scope', 'rtSocket', ($scope, rtSocket) ->
      # 连接状态监视
      $scope.rtStatus = 'disconnected'
      $scope.rtConnectionRetries = 0

      rtSocket.on 'connecting', () ->
        $scope.rtStatus = 'connecting'

      rtSocket.on 'connect', () ->
        $scope.rtStatus = 'connected'
        $scope.rtConnectionRetries = 0

      rtSocket.on 'disconnect', () ->
        $scope.rtStatus = 'disconnected'

      rtSocket.on 'reconnecting', () ->
        $scope.rtStatus = 'reconnecting'
        $scope.rtConnectionRetries++

      console.log '[DebugFooter] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
