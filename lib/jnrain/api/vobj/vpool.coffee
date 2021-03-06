define [
  'angular'
  'lodash'

  'jnrain/api/bridge'
], (angular, _) ->
  'use strict'

  # 返回值是作为 DSAPI 的一个属性而存在的, 所以没有用模块做包装
  (APIv1) ->
    basePath = () ->
      APIv1.one 'vtp'

    basePathWithID = (vtpid) ->
      basePath().one vtpid

    # 以下为暴露 API
    stat: (vtpid, callback) ->
      basePathWithID(vtpid).one('stat').get().then (data) ->
        retcode = data.r
        if retcode == 0
          callback 0,
            name: data.s.n
            natural: data.s.t
            xattr: data.s.x
        else
          callback retcode, null

    readdir: (vtpid, callback) ->
      basePathWithID(vtpid).one('readdir').get().then (data) ->
        retcode = data.r
        if retcode == 0
          vtags = _.transform(data.t, ((result, item) ->
            result[item.i] =
              name: item.n
              slug: item.s
              desc: item.d
          ), {})

          callback 0, vtags
        else
          callback retcode, null


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
