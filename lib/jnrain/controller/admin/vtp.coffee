define [
  'angular'
  'angular-route'

  'jnrain/provider/vpool'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/admin/vtp', [
    'ngRoute'
    'jnrain/provider/vpool'
  ]

  # 虚线索池管理视图
  mod.controller 'VTPAdmin',
    ($scope, $routeParams, VPool) ->
      $scope.params = $routeParams

      console.log '[VTPAdmin] $routeParams = ', $routeParams
      console.log '[VTPAdmin] $scope = ', $scope

  mod.config ($routeProvider) ->
    $routeProvider.when '/admin/vtp/:vtpid',
      templateUrl: 'admin/vtp.html'
      controller: 'VTPAdmin'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
