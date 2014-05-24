define [
  'angular'

  'jnrain/api/ds'
  'angular-ui-router'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vth/index', [
    'ui.router'
    'jnrain/api/ds'
  ]

  mod.controller 'VThreadIndexPage',
    ($scope, $state, $log, DSAPI) ->
      $log = $log.getInstance 'VThreadIndexPage'

      # XXX: kludge
      resolvedData = $state.$current.locals.globals
      vthid = resolvedData.vthid

      $scope.vthid = vthid

      # TODO

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'vtp.vtag.vth',
      # TODO: 支持 URL slug
      url: '/a/:vthid'
      resolve:
        vthid: [
          '$stateParams'
          ($stateParams) ->
            $stateParams.vthid
        ]
        navData: () ->
          # TODO: 注射虚线索元数据于此, 展示对应标题
          title: '阅读主题'
      abstract: true
      views:
        main:
          templateUrl: 'vth/index.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
