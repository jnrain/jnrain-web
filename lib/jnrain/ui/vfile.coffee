define [
  'angular'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/ui/vfile', [
  ]

  # 虚文件组件
  mod.controller 'VFileComponent',
    ($scope, $log) ->
      $log = $log.getInstance 'VFileComponent'

      vfid = null
      isRoot = false
      replies = []

      $scope.$watch 'vfid', (to, from) ->
        if to?
          vfid = to
          $log.debug 'vfid set to ', vfid

      $scope.$watch 'isRoot', (to, from) ->
        isRoot = !!to
        $log.debug 'isRoot set to ', isRoot

      $scope.$watch 'replies', (to, from) ->
        if to?
          replies = to
          $log.debug 'replies set to ', replies

      $log.debug '$scope = ', $scope

  mod.directive 'jnrainVf', () ->
    restrict: 'E'
    scope:
      vfid: '='
      isRoot: '='
      replies: '='
    controller: 'VFileComponent'
    templateUrl: 'vf/component.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
