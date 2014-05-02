define [
  'angular'
  'ui-bootstrap'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/ui/modal', [
    'ui.bootstrap'
  ]

  # 模态弹层
  mod.factory 'ModalDlg',
    ($modal, $log) ->
      $log = $log.getInstance 'ui/modal'

      showModal = (options, callback, dismissCallback) ->
        modalInstance = $modal.open options
        modalInstance.result.then((() ->
          $log.info 'modal dialog closed'
          callback?.apply this, arguments
        ), (() ->
          $log.info 'modal dialog dismissed'
          dismissCallback?()
        ))

      # 暴露 API
      show: showModal


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
