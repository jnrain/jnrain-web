define [
  'angular'
  'angular-ui-router'
  'angular-logex'

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
      'log.ex.uo'
    ]

    mod.config ($locationProvider) ->
      $locationProvider.html5Mode true
      $locationProvider.hashPrefix '!'

    mod.config (logExProvider) ->
      # TODO: 引入预处理, 在这里分化调试和生产环境设置
      logExProvider.enableLogging true

      # 自定义 log 信息前缀...
      logExProvider.overrideLogPrefix (className) ->
        timeFrag = '[' + new Date().toISOString() + '] '
        if angular.isString className
          classFrag = '[' + className + '] '
        else
          classFrag = ''

        timeFrag + classFrag

    angular.bootstrap angular.element('#appmount'), [
      'jnrain/main'
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
