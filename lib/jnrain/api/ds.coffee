define [
  'angular'

  'jnrain/api/vobj/vpool'
  'jnrain/api/vobj/vtag'
  'jnrain/api/vobj/vthread'
  'jnrain/api/vobj/vfile'
], (angular, vpool, vtag, vthread, vfile) ->
  'use strict'

  mod = angular.module 'jnrain/api/ds', [
    'jnrain/api/bridge'
  ]

  mod.factory 'DSAPI', (APIv1) ->
    vpool: vpool APIv1
    vtag: vtag APIv1
    vthread: vthread APIv1
    vfile: vfile APIv1


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
