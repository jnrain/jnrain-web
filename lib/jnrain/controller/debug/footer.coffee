define ['angular', 'jnrain/api/bridge', 'jnrain/ui/toasts'], (angular) ->
  (app) ->
    # footer 调试信息
    app.controller 'DebugFooter', ['$scope', 'rtSocket', 'Toasts', ($scope, rtSocket, Toasts) ->
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
        Toasts.toast 'success', '成功建立实时连接', '实时信道已成功连接。'

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
        Toasts.toast 'warning', '实时连接中断', '实时信道连接已断开。'

      rtSocket.on 'reconnecting', () ->
        $scope.rtStatus = 'reconnecting'
        $scope.rtConnectionRetries++

      console.log '[DebugFooter] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
