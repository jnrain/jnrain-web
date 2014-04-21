define [
  'angular'
  'lodash'
  'jsSHA'

  'jnrain/api/session'
], (angular, _, jsSHA) ->
  (app) ->
    # 登陆 (登陆 token 请求) 表单
    app.controller 'Login', [
      '$scope'
      'sessionAPI'
      ($scope, sessionAPI) ->
        $scope.submitInProgress = false

        # 是否已经有记录登陆 token?
        $scope.alreadyHaveToken = sessionAPI.getLoginToken()?

        $scope.doLogin = () ->
          $scope.submitInProgress = true

          name = $scope.name
          psw = $scope.psw
          pswHash = new jsSHA(psw, 'TEXT').getHash 'SHA-512', 'HEX'

          sessionAPI.authenticate name, pswHash, (retcode, token) ->
            $scope.submitInProgress = false

            if retcode != 0
              # 认证失败
              console.log '[Login] Authentication failed, retcode = ', retcode
            else
              # 认证成功
              console.log '[Login] Authentication OK: token = ', token
              # TODO: 跳转回首页或其他页面

        console.log '[Login] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
