define [
  'angular'

  'jnrain/controller/index'
], (angular) ->
  'use strict'

  boot: () ->
    mod = angular.module 'jnrain/main', [
      'jnrain/controller/index'

      'btford.socket-io'
      'ui.select2'
      'ui.bootstrap'
    ]

    angular.bootstrap angular.element('#appmount'), [
      'jnrain/main'
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
