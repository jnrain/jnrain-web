define [
  'angular'

  'jnrain/controller/vf/read'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/ui/vfile', [
    'jnrain/controller/vf/read'
  ]

  # 虚文件 directive
  mod.directive 'jnrainVfRead', () ->
    restrict: 'E'
    scope:
      vfid: '='
      isRoot: '='
      replies: '='
    controller: 'VFileReadComponent'
    templateUrl: 'vf/read.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
