define [
  'angular'

  'jnrain/api/bridge'
], (angular) ->
  'use strict'

  (APIv1) ->
    basePath = () ->
      APIv1.one('vf')

    basePathWithID = (vfid) ->
      basePath().one vfid

    # 暴露 API
    read: (vfid, callback) ->
      basePathWithID(vfid).one('read').get().then (data) ->
        retcode = data.r
        if retcode == 0
          callback 0,
            title: data.s.t
            owner: data.s.o
            ctime: new Date(data.s.c * 1000)
            content: data.s.n
            format: data.s.f
            xattr: data.s.x
        else
          callback retcode, null

    creat: (
      content,
      title=null,
      vthid=null,
      vtpid=null,
      vtags=null,
      reply=null,
      callback=null,
    ) ->
      # 构造请求数据
      if vthid?
        # 新建回复请求
        payload =
          vthid: vthid
          content: content

        payload.title = title if title?
        payload.inreply2 = reply if reply?
      else
        # 新建虚线索请求
        payload =
          vtpid: vtpid
          vtags: vtags
          title: title
          content: content

      basePath().one('creat').customPOST(payload).then (data) ->
        retcode = data.r
        if retcode == 0
          callback? 0, data.f, data.t
        else
          callback? retcode, null, null


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
