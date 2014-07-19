define [
  'angular'
  'angular-ui-router'

  'jnrain/api/ident'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/verifymail', [
    'ui.router'
    'jnrain/api/ident'
  ]

  # 邮箱验证
  mod.controller 'VerifyMailPage',
    ($scope, $state, $stateParams, $timeout, $log, IdentAPI) ->
      $log = $log.getInstance 'VerifyMailPage'

      doRedirect = () ->
        # 登陆页面
        $state.go 'login'

      $scope.inProgress = true
      $scope.retcode = -1

      $scope.activationKey = $stateParams.activationKey

      # 进行 API 请求
      IdentAPI.verifyMail $scope.activationKey, (retcode) ->
        if retcode == 0
          $log.info 'OK'
        else
          $log.warn 'failed, retcode=', retcode

        $scope.inProgress = false
        $scope.retcode = retcode

        # 5 秒后自动返回首页
        $timeout doRedirect, 5000

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'verifymail',
      url: '/verifymail/{activationKey:[0-9A-Za-z_-]{32}}'
      data:
        title: '验证注册邮箱'
      views:
        main:
          templateUrl: 'verifymail.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
