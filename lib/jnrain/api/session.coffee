define ['angular', 'lodash', 'jnrain/api/bridge'], (angular, _) ->
  mod = angular.module 'jnrain/api/session', ['jnrain/api/bridge']

  mod.factory 'sessionAPI', ['APIv1', (APIv1) ->
    basePath = () ->
      APIv1.one('session')

    authenticate: (name, pass, callback) ->
      basePath().one('auth').customPOST(
        name: name
        pass: pass
      ).then (data) ->
        retcode = data.r
        token = data.t if retcode == 0
        callback retcode, token

    refresh: (token, callback) ->
      basePath().one('refresh').customPOST(
        token: token
      ).then (data) ->
        callback data.r

    logout: (callback) ->
      basePath().one('logout').customPOST().then (data) ->
        callback data.r
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
