define [
  'angular'
  'lodash'
  'angular-local-storage'

  'jnrain/api/bridge'
], (angular, _) ->
  'use strict'

  mod = angular.module 'jnrain/api/session', [
    'jnrain/api/bridge'
    'LocalStorageModule'
  ]

  mod.factory 'SessionAPI',
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

      getUID = () ->
        localStorageService.get 'uid'

      setUID = (uid) ->
        removeUID()
        localStorageService.add 'uid', uid

      removeUID = () ->
        localStorageService.remove 'uid'

      # 以下是返回对象 (暴露 API)
      getLoginToken: getLoginToken
      getUID: getUID

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
          retcode = data.r

          if retcode == 0
            setUID data.u

          callback data.r

      logout: (callback) ->
        basePath().one('logout').customPOST().then (data) ->
          removeLoginToken()
          removeUID()
          callback data.r


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
