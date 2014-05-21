define [
  'angular'
  'angular-ui-router'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vtp/index', [
    'ui.router'
  ]

  mod.config ($stateProvider) ->
    $stateProvider.state 'vtp',
      url: '/p/:vtpid'
      resolve:
        vtpid: [
          '$stateParams'
          ($stateParams) ->
            $stateParams.vtpid
        ]
        navData: () ->
          # TODO: 带上虚线索池的名字
          title: '版块分组'
      views:
        main:
          template: '<div data-ui-view="main"></div>'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
