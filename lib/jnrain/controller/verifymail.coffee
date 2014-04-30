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
  mod.controller 'VerifyMail',
    ($scope, $state, $stateParams, $timeout, IdentAPI) ->
      doRedirect = () ->
        # 首页
        $state.go 'home'

      $scope.inProgress = true
      $scope.retcode = -1

      $scope.activationKey = $stateParams.activationKey

      # 进行 API 请求
      IdentAPI.verifyMail $scope.activationKey, (retcode) ->
        console.log '[VerifyMail] retcode = ', retcode
        $scope.inProgress = false
        $scope.retcode = retcode

        # 5 秒后自动返回首页
        $timeout doRedirect, 5000

      console.log '[VerifyMail] $scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'verifymail',
      url: '/verifymail/{activationKey:[0-9A-Za-z_-]{32}}'
      data:
        title: '验证注册邮箱'
      views:
        main:
          templateUrl: 'verifymail.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
