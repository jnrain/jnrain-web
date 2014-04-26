define [
  'angular',

  'jnrain/api/session'
  'jnrain/ui/toasts'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/logout', [
    'jnrain/api/session'
    'jnrain/ui/toasts'
  ]

  # 注销
  mod.controller 'LogoutPage',
    ($scope, $window, $timeout, sessionAPI, Toasts) ->
      doLogoutRedirect = () ->
        # 首页
        $window.location.href = '/'

      $scope.inProgress = true
      $scope.retcode = -1

      sessionAPI.logout (retcode) ->
        console.log '[LogoutPage] retcode = ', retcode
        $scope.inProgress = false
        $scope.retcode = retcode

        Toasts.toast 'info', '注销成功', '您已成功注销。'

        # 2 秒后跳转回首页
        $timeout doLogoutRedirect, 2000

      console.log '[LogoutPage] $scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
