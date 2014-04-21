define [
  'angular'
  'lodash'
  'angular-local-storage'

  'jnrain/api/bridge'
], (angular, _) ->
  mod = angular.module 'jnrain/api/session', ['jnrain/api/bridge', 'LocalStorageModule']

  mod.factory 'sessionAPI', [
    'APIv1'
    'localStorageService'
    (APIv1, localStorageService) ->
      basePath = () ->
        APIv1.one('session')

      getLoginToken = () ->
        localStorageService.get 'authToken'

      setLoginToken = (token) ->
        removeLoginToken()
        localStorageService.add 'authToken', token

      removeLoginToken = () ->
        localStorageService.remove 'authToken'

      # 以下是返回对象 (暴露 API)
      getLoginToken: getLoginToken

      authenticate: (name, pass, callback) ->
        basePath().one('auth').customPOST(
          name: name
          pass: pass
        ).then (data) ->
          retcode = data.r
          token = data.t if retcode == 0
          setLoginToken token if token?
          callback retcode, token

      refresh: (callback) ->
        basePath().one('refresh').customPOST(
          token: getLoginToken()
        ).then (data) ->
          callback data.r

      logout: (callback) ->
        basePath().one('logout').customPOST().then (data) ->
          removeLoginToken()
          callback data.r
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
