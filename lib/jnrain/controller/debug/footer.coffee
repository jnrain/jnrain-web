define ['angular', 'jnrain/api/bridge'], (angular) ->
  (app) ->
    # footer 调试信息
    app.controller 'DebugFooter', ['$scope', 'rtSocket', ($scope, rtSocket) ->
      # 后端版本
      $scope.versions =
        weiyu: 'xxxxyyyy'
        luohua: 'zzzzwwww'

      # 实时信道
      # 连接状态监视
      $scope.rtStatus = 'disconnected'
      $scope.rtConnectionRetries = 0

      rtSocket.on 'connecting', () ->
        $scope.rtStatus = 'connecting'

      rtSocket.on 'connect', () ->
        $scope.rtStatus = 'connected'
        $scope.rtConnectionRetries = 0

        # 事件处理
        # hello 回应
        rtSocket.on 'helloAck', (data) ->
          console.log '[DebugFooter] RT: helloAck: ', data

          # 更新 footer 后端版本信息展示
          $scope.versions.weiyu = data.versions.weiyu
          $scope.versions.luohua = data.versions.luohua

        # 发送 hello
        rtSocket.emit 'hello'

      rtSocket.on 'disconnect', () ->
        $scope.rtStatus = 'disconnected'

      rtSocket.on 'reconnecting', () ->
        $scope.rtStatus = 'reconnecting'
        $scope.rtConnectionRetries++

      console.log '[DebugFooter] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
