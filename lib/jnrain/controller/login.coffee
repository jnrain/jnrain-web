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

  # 登录 (登录 token 请求) 表单
  mod.controller 'LoginPage',
    ($scope, $state, $timeout, SessionAPI, Toasts) ->
      doLoginSuccessRedirect = () ->
        # 首页
        $state.go 'home'

      # 防止重复提交
      $scope.submitInProgress = false

      # 是否已经有记录登录 token?
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
            console.log '[LoginPage] Auth. failed, retcode = ', retcode

            # TODO: 错误消息
            Toasts.toast 'error', '登录失败', '登录失败: ' + retcode
          else
            # 认证成功
            console.log '[LoginPage] Auth. OK: token = ', token

            Toasts.toast 'info', '登录成功', '您已成功登录。'

            # 2 秒后跳转回首页
            $timeout doLoginSuccessRedirect, 2000

      # 已经有记录登录 token 的话也回首页
      $timeout doLoginSuccessRedirect, 2000 if alreadyHaveToken

      console.log '[LoginPage] $scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'login',
      url: '/login'
      data:
        title: '登录'
      views:
        main:
          templateUrl: 'login.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
