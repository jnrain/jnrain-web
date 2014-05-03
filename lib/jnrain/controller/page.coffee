define [
  'angular'

  'jnrain/ui/page'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/page', [
    'jnrain/ui/page'
  ]

  # 页面标题
  mod.controller 'PageTitle',
    ($scope, $state, $log, PageGlobals) ->
      $log = $log.getInstance 'PageTitle'

      $scope.dynTitlePrefix = ''
      $scope.stateTitle = ''
      $scope.$state = $state

      $scope.$on '$stateChangeSuccess',
        (evt, toState, toParams, fromState, fromParams) ->
          # 更新内部导航状态
          PageGlobals.updateState $state

          newTitleFrags = PageGlobals.getTitleFrags()
          $log.info 'State changed: newTitleFrags = ', newTitleFrags
          $scope.stateTitle = newTitleFrags.join ' - '

      $log.debug '$scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
