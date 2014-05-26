define [
  'angular'

  'jnrain/api/ds'
  'jnrain/ui/toasts'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/vf/newreply', [
    'jnrain/api/ds'
    'jnrain/ui/toasts'
  ]

  mod.controller 'VFileNewReplyComponent',
    ($scope, $rootScope, $timeout, $log, DSAPI, Toasts) ->
      $log = $log.getInstance 'VFileNewReplyComponent'

      $scope.requestInProgress = false

      vfReplyCallback = (retcode, vfid, vthid) ->
        $scope.requestInProgress = false

        if retcode == 0
          $log.info 'vf creat OK: vfid=', vfid
        else
          $log.warn 'vf creat failed; retcode=', retcode

          Toasts.toast(
            'warn',
            '发表回复失败',
            '您的回复未能成功发表，错误码：' + retcode,
          )

          return

        Toasts.toast(
          'info',
          '回复成功',
          '您的回复已发表。',
        )

      $scope.doCreateVFileReply = () ->
        vthid = $scope.vthid
        inreply2 = if $scope.inReplyTo? then $scope.inReplyTo else null
        content = $scope.content

        unless vthid? and !!content
          return

        $scope.requestInProgress = true
        DSAPI.vfile.creat(
          content,
          null,  # title
          vthid,  # vthid
          null,  # vtpid
          null,  # vtags
          inreply2,
          vfReplyCallback,
        )

      $log.debug '$scope = ', $scope


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
