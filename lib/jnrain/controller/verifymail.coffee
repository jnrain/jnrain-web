define [
  'angular'

  'jnrain/api/ident'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/verifymail', [
    'jnrain/api/ident'
  ]

  # 邮箱验证
  mod.controller 'VerifyMail',
    ($scope, $window, $timeout, identAPI) ->
      doRedirect = () ->
        # 首页
        $window.location.href = '/'

      $scope.inProgress = true
      $scope.retcode = -1

      # 从页面中解出 activationKey
      getActivationKey = () ->
        angular.element('#activation-key').text().trim()
      $scope.activationKey = getActivationKey()

      # 进行 API 请求
      identAPI.verifyMail $scope.activationKey, (retcode) ->
        console.log '[VerifyMail] retcode = ', retcode
        $scope.inProgress = false
        $scope.retcode = retcode

        # 5 秒后自动返回首页
        $timeout doRedirect, 5000

      console.log '[VerifyMail] $scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
