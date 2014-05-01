define [
  'angular'
  'lodash'

  'jnrain/api/bridge'
], (angular, _) ->
  'use strict'

  (APIv1) ->
    basePath = (vtpid) ->
      APIv1.one('vtp').one(vtpid).one 'vtag'

    basePathWithID = (vtpid, vtagid) ->
      basePath(vtpid).one vtagid

    # 暴露 API
    stat: (vtpid, vtagid, callback) ->
      basePathWithID(vtpid, vtagid).one('stat').get().then (data) ->
        retcode = data.r
        if retcode == 0
          callback 0,
            name: data.s.n
            desc: data.s.d
            natural: data.s.t
            xattr: data.s.x
        else
          callback retcode, null

    creat: (vtpid, name, desc, callback, vtagid=null) ->
      payload =
        name: name
        desc: desc

      # 省略则自动生成
      payload.vtagid = vtagid if vtagid?

      basePath(vtpid).one('creat').customPOST(payload).then (data) ->
        retcode = data.r
        if retcode == 0
          vtagid = data.t
          callback 0, vtagid
        else
          callback retcode, null

    readdir: (vtpid, vtagid, startTime, endTime, callback) ->
      # 时间戳
      tsStart = Math.floor +startTime / 1000
      tsEnd = Math.floor +endTime / 1000

      basePathWithID(vtpid, vtagid)
        .one('readdir')
        .one('' + tsStart)
        .one('' + tsEnd)
        .get()
        .then (data) ->
          retcode = data.r
          if retcode == 0
            vthList = _.map data.l, (v) ->
              vthid: v.i
              title: v.t
              owner: v.o
              ctime: new Date(1000 * v.c)
              mtime: new Date(1000 * v.m)

            callback 0, vthList
          else
            callback retcode, null


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
