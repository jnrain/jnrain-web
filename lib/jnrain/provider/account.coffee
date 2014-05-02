define [
  'angular'

  'jnrain/config'
  'jnrain/api/session'
  'jnrain/api/account'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/provider/account', [
    'jnrain/api/session'
    'jnrain/api/account'
  ]

  # 用户信息组件
  mod.factory 'Account',
    (
      $rootScope,
      $timeout,
      $log,
      SessionAPI,
      AccountAPI,
      sessionRefreshInterval,
    ) ->
      $log = $log.getInstance 'Account'

      # 是否已经有记录登录 token?
      alreadyHaveToken = () ->
        SessionAPI.getLoginToken()?

      # 当前用户信息
      selfInfo = {}

      getSelfInfo = () ->
        selfInfo

      setSelfInfo = (info) ->
        selfInfo = info
        $rootScope.$broadcast 'provider:accountRefreshed'

      refreshUserStatCallback = (retcode, info) ->
        if retcode == 0
          $log.info 'self info refreshed: ', info
          setSelfInfo info
        else
          $log.warn 'self info refresh failed: retcode = ', retcode

      # 隔一段时间就刷新一下会话确保服务器端 session 存活, 避免不必要的麻烦
      refreshTimer = null
      refreshSession = () ->
        SessionAPI.refresh (retcode) ->
          if retcode == 0
            $log.info 'Session refresh OK'

            # 如果已登录, 刷新用户信息
            AccountAPI.statSelf(refreshUserStatCallback) if alreadyHaveToken()
          else
            $log.warn 'Session refresh failed, retcode = ', retcode

        # "隔一段时间再刷新"
        # 无论上次刷新是否成功, 都周期性刷新
        $timeout.cancel refreshTimer if refreshTimer?
        refreshTimer = $timeout refreshSession, sessionRefreshInterval

      # 暴露 API
      alreadyHaveToken: alreadyHaveToken
      getSelfInfo: getSelfInfo
      refreshSession: refreshSession


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
