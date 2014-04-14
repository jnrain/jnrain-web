define ['angular', 'lodash', 'jnrain/api/bridge'], (angular, _) ->
  mod = angular.module 'jnrain/api/univ', ['jnrain/api/bridge']

  mod.factory 'univInfo', ['APIv1', (APIv1) ->
    getBasicInfo: (callback) ->
      APIv1.one('univ').one('basic').get().then (data) ->
        info =
          name: data.n
          aliases: data.a
          address: data.d
          postal: data.p
          homepage: data.h
        callback info

    getDormsInfo: (callback) ->
      APIv1.one('univ').one('dorms').get().then (data) ->
        buildings = _.mapValues data.d, (v, k) ->
          campus: v.c
          group: v.p
          gender: v.g
        callback buildings
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
