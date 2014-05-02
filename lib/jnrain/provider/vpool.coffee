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

  mod.factory 'VPool',
    ($rootScope, $log, DSAPI, localStorageService) ->
      $log = $log.getInstance 'provider/vpool'

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

        # 通知刷新
        $rootScope.$broadcast 'provider:vtpDataUpdated', vtpid, stat, vtags

      doRefresh = (vtpid, callback) ->
        # 查询基本信息
        DSAPI.vpool.stat vtpid, (retcode, stat) ->
          if retcode == 0
            $log.info 'vtpid=', vtpid, ' stat OK: ', stat
          else
            $log.warn 'vtpid=', vtpid, ' stat failed: retcode=', retcode

          unless retcode == 0
            return callback? retcode, null, 'stat'

          # 查询虚标签
          DSAPI.vpool.readdir vtpid, (retcode, vtags) ->
            if retcode == 0
              $log.info 'vtpid=', vtpid, ' readdir OK: ', vtags
            else
              $log.warn 'vtpid=', vtpid, ' readdir failed: retcode=', retcode

            unless retcode == 0
              return callback? retcode, null, 'readdir'

            # 两步查询均成功, 记录信息到浏览器存储
            setVPoolData vtpid, stat, vtags
            callback? 0, getVPoolData(vtpid), null

      maybeRefresh = (vtpid, callback) ->
        if shouldRefresh vtpid
          doRefresh vtpid, callback
        else
          # 装作刚刚刷新完的样子
          data = getVPoolData vtpid
          $rootScope.$broadcast(
            'provider:vtpDataUpdated',
            vtpid,
            data.stat,
            data.vtags,
          )
          callback? 0, data, null

      createVTag = (vtpid, name, desc, callback, vtagid=null) ->
        wrappedCallback = (retcode, vtagid) ->
          # 如果创建成功, 强制刷新本虚线索池的信息
          doRefresh vtpid if retcode == 0
          # 调用真正的回调函数
          callback retcode, vtagid

        DSAPI.vtag.creat vtpid, name, desc, wrappedCallback, vtagid

      # 暴露 API
      GLOBAL_VPOOL: GLOBAL_VPOOL
      getVPoolLastRefreshTime: getVPoolLastRefreshTime
      shouldRefresh: shouldRefresh
      maybeRefresh: maybeRefresh
      forceRefresh: doRefresh
      getVPoolData: getVPoolData
      createVTag: createVTag


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
