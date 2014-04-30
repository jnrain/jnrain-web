define [
  'angular'
  'lodash'
  'jsSHA'
  'angular-ui-router'

  'jnrain/api/session'
  'jnrain/ui/toasts'
], (angular, _, jsSHA) ->
  'use strict'

  mod = angular.module 'jnrain/controller/login', [
    'ui.router'
    'jnrain/api/session'
    'jnrain/ui/toasts'
  ]

  # 登陆 (登陆 token 请求) 表单
  mod.controller 'Login',
    ($scope, $state, $timeout, SessionAPI, Toasts) ->
      doLoginSuccessRedirect = () ->
        # 首页
        $state.go 'home'

      # 防止重复提交
      $scope.submitInProgress = false

      # 是否已经有记录登陆 token?
      alreadyHaveToken = SessionAPI.getLoginToken()?
      $scope.alreadyHaveToken = alreadyHaveToken

      $scope.doLogin = () ->
        $scope.submitInProgress = true

        name = $scope.name
        psw = $scope.psw
        pswHash = new jsSHA(psw, 'TEXT').getHash 'SHA-512', 'HEX'

        SessionAPI.authenticate name, pswHash, (retcode, token) ->
          $scope.submitInProgress = false

          if retcode != 0
            # 认证失败
            console.log '[Login] Authentication failed, retcode = ', retcode

            # TODO: 错误消息
            Toasts.toast 'error', '登陆失败', '登陆失败: ' + retcode
          else
            # 认证成功
            console.log '[Login] Authentication OK: token = ', token

            Toasts.toast 'info', '登陆成功', '您已成功登陆。'

            # 2 秒后跳转回首页
            $timeout doLoginSuccessRedirect, 2000

      # 已经有记录登陆 token 的话也回首页
      $timeout doLoginSuccessRedirect, 2000 if alreadyHaveToken

      console.log '[Login] $scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'login',
      url: '/login'
      data:
        title: '登陆'
      views:
        main:
          templateUrl: 'login.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
