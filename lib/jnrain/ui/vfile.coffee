define [
  'angular'

  'jnrain/controller/vf/component'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/ui/vfile', [
    'jnrain/controller/vf/component'
  ]

  # 虚文件 directive
  mod.directive 'jnrainVf', () ->
    restrict: 'E'
    scope:
      vfid: '='
      isRoot: '='
      replies: '='
    controller: 'VFileComponent'
    templateUrl: 'vf/component.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
