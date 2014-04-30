define [
  'angular'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/ui/page', [
  ]

  # 网页全局设置
  mod.factory 'PageGlobals',
    ($rootScope, $log) ->
      currentTitleFrag = ''

      # 页面标题的动态部分
      titleFrag = (value) ->
        if value?
          $log.info '[PageGlobals] dynamic title fragment set to ', value
          currentTitleFrag = '' + value
          $rootScope.$broadcast 'ui:pageTitleFragChanged'
        else
          currentTitleFrag

      getTitlePrefix = () ->
        if currentTitleFrag then currentTitleFrag + ' - ' else ''

      # 暴露 API
      titleFrag: titleFrag
      getTitlePrefix: getTitlePrefix


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
