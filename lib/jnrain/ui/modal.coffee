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
      showModal = (options, callback, dismissCallback) ->
        modalInstance = $modal.open options
        modalInstance.result.then((() ->
          $log.info '[jnrain/ui/modal] modal dialog closed'
          callback?.apply this, arguments
        ), (() ->
          $log.info '[jnrain/ui/modal] modal dialog dismissed'
          dismissCallback?()
        ))

      # 暴露 API
      show: showModal


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
