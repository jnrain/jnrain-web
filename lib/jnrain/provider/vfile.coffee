define [
  'angular'
  'angular-local-storage'

  'jnrain/api/ds'
], (angular) ->
  'use strict'

  # TODO: 参见 provider/vthread 的此处
  mod = angular.module 'jnrain/provider/vfile', [
    'jnrain/api/ds'
    'LocalStorageModule'
  ]

  mod.factory 'VFile',
    ($rootScope, $log, DSAPI, localStorageService) ->
      $log = $log.getInstance 'provider/vfile'

      shouldRefresh = (vfid) ->
        # placeholder
        true

      getVFileDataKey = (vfid) ->
        'vf:' + vfid

      getVFileData = (vfid) ->
        tmp = localStorageService.get getVFileDataKey vfid

        # 重建 Date 对象...
        tmp.ctime = new Date(tmp.ctime)
        tmp.mtime = new Date(tmp.mtime)

        tmp

      setVFileData = (vfid, data) ->
        key = getVFileDataKey vfid
        localStorageService.set key, data

        # 通知刷新
        $rootScope.$broadcast 'provider:vf:updated', vfid, data

      doRefresh = (vfid, callback) ->
        DSAPI.vfile.read vfid, (retcode, data) ->
          if retcode == 0
            $log.info 'vfid=', vfid, ': read OK: ', data

            # 记录信息
            setVFileData vfid, data

            callback? 0, getVFileData vfid
          else
            $log.warn 'vfid=', vfid, ': read failed: retcode=', retcode
            callback? retcode, null

      maybeRefresh = (vfid, callback) ->
        # TODO
        doRefresh vfid, callback

      # 暴露 API
      shouldRefresh: shouldRefresh
      maybeRefresh: maybeRefresh
      forceRefresh: doRefresh
      getVFileData: getVFileData


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
