define [
  'angular'

  'jnrain/api/ds'
  'angular-ui-router'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vf/newvth', [
    'ui.router'
    'jnrain/api/ds'
  ]

  mod.controller 'NewVFileWithVThread',
    ($scope, $state, $log, DSAPI) ->
      $log = $log.getInstance 'NewVFileWithVThread'

      # XXX kludge
      resolvedData = $state.$current.locals.globals
      vtpid = resolvedData.vtpid
      vtagid = resolvedData.vtagid
      vtagInfo = resolvedData.vtagInfo

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'vtp.vtag.newvth',
      url: '/post'
      resolve:
        navData: () ->
          title: '发表一个话题'
      views:
        main:
          templateUrl: 'vf/newvth.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
