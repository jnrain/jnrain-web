define [
  'angular'
  'angular-route'

  'jnrain/controller/index'
], (angular) ->
  'use strict'

  boot: () ->
    mod = angular.module 'jnrain/main', [
      'ngRoute'

      'jnrain/controller/index'

      'btford.socket-io'
      'ui.select2'
      'ui.bootstrap'
    ]

    mod.config ($locationProvider) ->
      $locationProvider.html5Mode true
      $locationProvider.hashPrefix '!'

    angular.bootstrap angular.element('#appmount'), [
      'jnrain/main'
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
