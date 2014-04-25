define ['angular', 'restangular', 'angular-socket-io', 'jnrain/config'], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/api/bridge', ['restangular', 'jnrain/config']

  rawSocket = null

  mod.factory 'APIv1', (Restangular, apiDomain) ->
    Restangular.withConfig (RestangularConfigurer) ->
      RestangularConfigurer.setBaseUrl apiDomain + '/v1'
      RestangularConfigurer.setRequestSuffix '/'
      RestangularConfigurer.setDefaultHttpFields
        withCredentials: true

  mod.factory '_raw_rtSocket',
    (rtDomain) ->
      if rawSocket?
        rawSocket
      else
        # io 貌似必须从 window 对象 (全局命名空间) 得到...
        rawSocket = io.connect rtDomain,
          reconnect: false

  mod.factory 'rtSocket',
    (socketFactory, rtDomain, _raw_rtSocket) ->
      socketFactory
        ioSocket: _raw_rtSocket


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
