define [
  'angular'
  'lodash'

  'jnrain/api/bridge'
], (angular, _) ->
  'use strict'

  (APIv1) ->
    basePathWithID = (vthid) ->
      APIv1.one('vth').one vthid

    # 暴露 API
    stat: (vthid, callback) ->
      basePathWithID(vthid).one('stat').get().then (data) ->
        retcode = data.r
        if retcode == 0
          callback 0,
            title: data.s.t
            owner: data.s.o
            ctime: new Date(data.s.c * 1000)
            mtime: new Date(data.s.m * 1000)
            vtags: data.s.g
            vtpid: data.s.p
            xattr: data.s.x
        else
          callback retcode, null

    readdir: (vthid, callback) ->
      basePathWithID(vthid).one('readdir').get().then (data) ->
        retcode = data.r
        if retcode == 0
          callback 0, data.l
        else
          callback retcode, null


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
