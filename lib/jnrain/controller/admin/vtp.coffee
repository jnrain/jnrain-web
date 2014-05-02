define [
  'angular'
  'angular-ui-router'
  'ui-bootstrap'

  'jnrain/provider/vpool'
  'jnrain/ui/modal'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/admin/vtp', [
    'ui.router'
    'ui.bootstrap'
    'jnrain/provider/vpool'
    'jnrain/ui/modal'
  ]

  # 虚线索池管理视图
  mod.controller 'VTPAdmin',
    ($scope, $stateParams, $modal, $log, VPool) ->
      $log = $log.getInstance 'VTPAdmin'

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

      $log.debug '$scope = ', $scope

  # 虚标签创建对话框
  mod.controller 'VTagCreatDlg',
    ($scope, $modalInstance, $timeout, $log, vtpid, VPool) ->
      $log = $log.getInstance 'VTagCreatDlg'

      $scope.vtpid = vtpid
      $scope.requestInProgress = false
      $scope.retcode = -1

      $scope.dismiss = () ->
        $scope.$dismiss()

      $scope.doCreat = (name, desc) ->
        $log.info 'name=', name, ', desc=', desc
        $scope.requestInProgress = true

        # TODO: 暴露自定义虚标签 ID 的功能
        VPool.createVTag vtpid, name, desc, (retcode, vtagid) ->
          $scope.requestInProgress = false
          $scope.retcode = retcode

          if retcode == 0
            $log.info 'vtag created: vtagid=', vtagid
            $timeout((() ->
              $modalInstance.close()
            ), 1500)
          else
            $log.warn 'vtag creation failed; retcode=', retcode

      $log.debug '$scope = ', $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'admin.vtp',
      url: '/vtp/:vtpid'
      data:
        title: '版块管理'
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
      data:
        title: '创建版块'
      onEnter: [
        '$state'
        '$stateParams'
        'ModalDlg'
        ($state, $stateParams, ModalDlg) ->
          modalOptions =
            templateUrl: 'admin/vtp/vtagCreatDlg.html'
            controller: 'VTagCreatDlg'
            backdrop: 'static'
            resolve:
              vtpid: () ->
                $stateParams.vtpid

          ModalDlg.show(
            modalOptions,
            (result) ->
              $state.go 'admin.vtp'
            , () ->
              # dismissed
              $state.go 'admin.vtp'
          )

          $log.info '[VTPAdmin] vtag creat dialog opened'
      ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
