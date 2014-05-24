define [
  'angular'
  'angular-local-storage'

  'jnrain/api/ds'
], (angular) ->
  'use strict'

  # TODO: 用 IndexedDB 或简单的 HTTP ETag 机制实现存储空间不受限的数据持久化
  mod = angular.module 'jnrain/provider/vthread', [
    'jnrain/api/ds'
    'LocalStorageModule'
  ]

  mod.factory 'VThread',
    ($rootScope, $log, DSAPI, localStorageService) ->
      $log = $log.getInstance 'provider/vthread'

      shouldRefresh = (vthid) ->
        # placeholder. 如果有必要加上客户端缓存的话, 哪怕只有几秒的有效期,
        # 只要代码事先都以假定存在缓存的形式书写, 也可以避免大量的改动
        true

      getVThreadDataKey = (vthid) ->
        'vth:' + vthid

      getVThreadData = (vthid) ->
        tmp = localStorageService.get getVThreadDataKey vthid

        # 重建 Date 对象...
        tmp.stat.ctime = new Date(tmp.stat.ctime)
        tmp.stat.mtime = new Date(tmp.stat.mtime)

        tmp

      setVThreadData = (vthid, stat, tree) ->
        key = getVThreadDataKey vthid
        localStorageService.set key,
          stat: stat
          tree: tree

        # 通知刷新
        $rootScope.$broadcast 'provider:vth:updated', vthid, stat, tree

      doRefresh = (vthid, callback) ->
        # 查询基本信息
        DSAPI.vthread.stat vthid, (retcode, stat) ->
          if retcode == 0
            $log.info 'vthid=', vthid, ' stat OK: ', stat
          else
            $log.warn 'vthid=', vthid, ' stat failed: retcode=', retcode

          unless retcode == 0
            return callback? retcode, null, 'stat'

          # 查询线索树
          DSAPI.vthread.readdir vthid, (retcode, tree) ->
            if retcode == 0
              $log.info 'vthid=', vthid, ' readdir OK: ', tree
            else
              $log.warn 'vthid=', vthid, ' readdir failed: retcode=', retcode

            unless retcode == 0
              return callback? retcode, null, 'readdir'

            # 记录信息
            setVThreadData vthid, stat, tree
            callback? 0, getVThreadData(vthid), null

      maybeRefresh = (vthid, callback) ->
        # TODO
        doRefresh vthid, callback

      # 暴露 API
      shouldRefresh: shouldRefresh
      maybeRefresh: maybeRefresh
      forceRefresh: doRefresh
      getVThreadData: getVThreadData


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
