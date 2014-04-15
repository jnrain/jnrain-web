define ['angular', 'restangular', 'angular-socket-io', 'jnrain/config'], (angular) ->
  mod = angular.module 'jnrain/api/bridge', ['restangular', 'jnrain/config']

  mod.factory 'APIv1', ['Restangular', 'apiDomain', (Restangular, apiDomain) ->
    Restangular.withConfig (RestangularConfigurer) ->
      RestangularConfigurer.setBaseUrl apiDomain + '/v1'
      RestangularConfigurer.setRequestSuffix '/'
      RestangularConfigurer.setDefaultHttpFields
        withCredentials: true
  ]

  mod.factory 'rtSocket', ['socketFactory', 'rtDomain', (socketFactory, rtDomain) ->
    # io 貌似必须从 window 对象 (全局命名空间) 得到...
    socketFactory
      ioSocket: io.connect rtDomain
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
