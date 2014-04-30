define [
  'angular'
  'angular-local-storage'

  'jnrain/api/ds'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/provider/vpool', [
    'jnrain/api/ds'
    'LocalStorageModule'
  ]

  mod.factory 'VPool', [
    'DSAPI'
    'localStorageService'
    (DSAPI, localStorageService) ->
      # 全局虚线索池 ID
      GLOBAL_VPOOL = '0'

      # TODO: 移动到 jnrain/config
      # 虚线索池信息刷新间隔, 单位: 毫秒
      vtpRefreshInterval = 24 * 3600 * 1000

      getVPoolLastRefreshTimeKey = (vtpid) ->
        'vtpLastRefreshed:' + vtpid

      getVPoolLastRefreshTime = (vtpid) ->
        localStorageService.get getVPoolLastRefreshTimeKey vtpid

      setVPoolLastRefreshTime = (vtpid, time) ->
        key = getVPoolLastRefreshTimeKey vtpid
        localStorageService.set key, time

      shouldRefresh = (vtpid) ->
        now = +new Date()
        lastRefreshed = getVPoolLastRefreshTime vtpid

        # 从未请求过, 或者上次刷新到现在已经过了至少 vtpRefreshInterval
        !lastRefreshed? or now - lastRefreshed > vtpRefreshInterval

      getVPoolDataKey = (vtpid) ->
        'vtpData:' + vtpid

      getVPoolData = (vtpid) ->
        localStorageService.get getVPoolDataKey vtpid

      setVPoolData = (vtpid, stat, vtags) ->
        # 记录刷新时间
        setVPoolLastRefreshTime vtpid, +new Date()

        key = getVPoolDataKey vtpid
        localStorageService.set key,
          stat: stat
          vtags: vtags

      doRefresh = (vtpid, callback) ->
        # 查询基本信息
        DSAPI.vpool.stat vtpid, (retcode, stat) ->
          console.log(
            '[provider/vpool] stat retcode=',
            retcode,
            ' stat=',
            stat,
          )
          unless retcode == 0
            return callback retcode, null, 'stat'

          # 查询虚标签
          DSAPI.vpool.readdir vtpid, (retcode, vtags) ->
            console.log(
              '[provider/vpool] readdir retcode=',
              retcode,
              ' vtags=',
              vtags,
            )
            unless retcode == 0
              return callback retcode, null, 'readdir'

            # 两步查询均成功, 记录信息到浏览器存储
            setVPoolData vtpid, stat, vtags
            callback 0, getVPoolData(vtpid), null

      maybeRefresh = (vtpid, callback) ->
        if shouldRefresh vtpid
          doRefresh vtpid, callback
        else
          # 直接回调, 装作刚刚刷新完的样子
          callback 0, getVPoolData(vtpid), null

      # 暴露 API
      GLOBAL_VPOOL: GLOBAL_VPOOL
      getVPoolLastRefreshTime: getVPoolLastRefreshTime
      shouldRefresh: shouldRefresh
      maybeRefresh: maybeRefresh
      forceRefresh: doRefresh
      getVPoolData: getVPoolData
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
