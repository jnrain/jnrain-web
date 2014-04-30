define [
  'angular'
  'angular-ui-router'
  'ui-bootstrap'

  'jnrain/provider/vpool'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/admin/vtp', [
    'ui.router'
    'ui.bootstrap'
    'jnrain/provider/vpool'
  ]

  # 虚线索池管理视图
  mod.controller 'VTPAdmin',
    ($scope, $stateParams, $modal, VPool) ->
      vtpid = $stateParams.vtpid

      $scope.GLOBAL_VPOOL = VPool.GLOBAL_VPOOL
      $scope.vtpid = vtpid
      $scope.requestInProgress = true
      $scope.retcode = null
      $scope.vtpStat = null
      $scope.vtpVTags = null
      $scope.errorPhase = null

      # 因为是管理界面... 应该请求最新的数据. 这里倒不用考虑太多性能问题,
      # 毕竟用管理界面的人比用户少多了
      VPool.forceRefresh vtpid, (retcode, data, errorPhase) ->
        $scope.requestInProgress = false
        $scope.retcode = retcode
        if retcode != 0
          $scope.errorPhase = errorPhase
        else
          $scope.vtpStat = data.stat
          $scope.vtpVTags = data.vtags

      console.info '[VTPAdmin] $scope = ', $scope

  # 虚标签创建对话框
  mod.controller 'VTagCreatDlg',
    ($scope, $modalInstance, vtpid) ->
      $scope.vtpid = vtpid

      $scope.dismiss = () ->
        $scope.$dismiss()

      console.log '[VTagCreatDlg] $scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'admin.vtp',
      url: '/vtp/:vtpid'
      controller: 'VTPAdmin'
      views:
        main:
          templateUrl: 'admin/vtp/index.html'

    $stateProvider.state 'admin.vtp.vtag',
      url: '/vtag'
      abstract: true
      views:
        main:
          template: '<div data-ui-view="main"></div>'

    $stateProvider.state 'admin.vtp.vtag.creat',
      url: '/creat'
      onEnter: [
        '$state'
        '$stateParams'
        '$modal'
        ($state, $stateParams, $modal) ->
          modalInstance = $modal.open
            templateUrl: 'admin/vtp/vtagCreatDlg.html'
            controller: 'VTagCreatDlg'
            resolve:
              vtpid: () ->
                $stateParams.vtpid

          modalInstance.result.then(((result) ->
            $state.go 'admin.vtp'
          ), (() ->
            # dismissed
            $state.go 'admin.vtp'
          ))

          console.info '[VTPAdmin] vtag creat dialog opened'
      ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
