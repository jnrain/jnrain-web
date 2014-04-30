define [
  'angular'

  'jnrain/provider/account'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/authbox', [
    'jnrain/provider/account'
  ]

  # 用户信息组件
  mod.controller 'AuthBox',
    ($scope, Account) ->
      $scope.alreadyHaveToken = false
      $scope.selfInfo = {}

      # 处理刷新事件
      $scope.$on 'session:refreshed', (evt) ->
        # 是否已经有记录登录 token?
        $scope.alreadyHaveToken = Account.alreadyHaveToken()

      $scope.$on 'provider:accountRefreshed', (evt) ->
        # 当前用户信息
        $scope.selfInfo = Account.getSelfInfo()

      # 登录/注销事件
      # 这些时候要刷新会话, 以同步组件界面显示 (也是为了自己好, 保证会话有效)
      $scope.$on 'session:authenticated', (evt) ->
        Account.refreshSession()

      $scope.$on 'session:loggedOut', (evt) ->
        Account.refreshSession()

      # 启动会话刷新
      Account.refreshSession()

      console.log '[AuthBox] $scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
