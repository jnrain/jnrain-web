define [
  'angular'
  'angular-ui-router'

  'jnrain/api/session'
  'jnrain/ui/toasts'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/logout', [
    'ui.router'
    'jnrain/api/session'
    'jnrain/ui/toasts'
  ]

  # 注销
  mod.controller 'LogoutPage',
    ($scope, $state, $timeout, sessionAPI, Toasts) ->
      doLogoutRedirect = () ->
        # 首页
        $state.go 'home'

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

  mod.config ($stateProvider) ->
    $stateProvider.state 'logout',
      url: '/logout'
      data:
        title: '注销'
      views:
        main:
          templateUrl: 'logout.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
