define ['angular', 'jnrain/controller/index'], (angular, controllers) ->
  boot: () ->
    mod = angular.module 'jnrain/main', ['ui.select2']
    controllers.registerWith mod

    angular.bootstrap angular.element('#appmount'), ['jnrain/main', 'jnrain/api/univ']


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
