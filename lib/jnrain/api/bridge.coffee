define ['angular', 'jnrain/config', 'restangular'], (angular) ->
  mod = angular.module 'jnrain/api/bridge', ['restangular', 'jnrain/config']

  mod.factory 'APIv1Restangular', ['Restangular', 'apiDomain', (Restangular, apiDomain) ->
    Restangular.withConfig (RestangularConfigurer) ->
      RestangularConfigurer.setBaseUrl apiDomain + '/v1'
      RestangularConfigurer.setRequestSuffix '/'
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
