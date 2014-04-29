define [
  'angular'
  'angular-ui-router'

  'jnrain/controller/index'
  'jnrain/ui/gen/templates'
], (angular) ->
  'use strict'

  boot: () ->
    mod = angular.module 'jnrain/main', [
      'jnrain/controller/index'
      'jnrain/ui/gen/templates'

      'btford.socket-io'
      'ui.select2'
      'ui.bootstrap'
      'ui.router'
    ]

    mod.config ($locationProvider) ->
      $locationProvider.html5Mode true
      $locationProvider.hashPrefix '!'

    angular.bootstrap angular.element('#appmount'), [
      'jnrain/main'
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
