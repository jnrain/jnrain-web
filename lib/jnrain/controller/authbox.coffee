define [
  'angular'

  'jnrain/config'
  'jnrain/api/session'
], (angular) ->
  (app) ->
    # 用户信息组件
    app.controller 'AuthBox', [
      '$scope'
      '$timeout'
      'sessionAPI'
      'sessionRefreshInterval'
      ($scope, $timeout, sessionAPI, sessionRefreshInterval) ->
        # 是否已经有记录登陆 token?
        $scope.alreadyHaveToken = sessionAPI.getLoginToken()?

        # 隔一段时间就刷新一下会话确保服务器端 session 存活, 避免不必要的麻烦
        refreshSession = () ->
          sessionAPI.refresh (retcode) ->
            console.log '[AuthBox] Token refresh retcode = ', retcode
            $timeout refreshSession, sessionRefreshInterval

        # 启动会话刷新
        refreshSession()

        console.log '[AuthBox] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
