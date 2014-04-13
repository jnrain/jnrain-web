define ['angular', 'jnrain/controller/foo'], (angular, foo) ->
  boot: () ->
    mod = angular.module 'jnrain/main', ['ui.select2']
    foo mod

    angular.bootstrap angular.element('#appmount'), ['jnrain/main', 'jnrain/univ']


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
