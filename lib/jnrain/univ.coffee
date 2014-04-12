define ['angular', 'jnrain/bridge'], (angular) ->
  mod = angular.module 'jnrain/univ', ['jnrain/bridge']

  mod.factory 'univInfo', ['APIv1Restangular', (APIv1Restangular) ->
    getBasicInfo: (callback) ->
      APIv1Restangular.one('univ').one('basic').get().then(callback)
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
