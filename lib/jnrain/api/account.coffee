define [
  'angular'
  'lodash'

  'jnrain/api/bridge'
  'jnrain/api/session'
], (angular, _) ->
  mod = angular.module 'jnrain/api/account', [
    'jnrain/api/bridge'
    'jnrain/api/session'
  ]

  ERROR_CODE_MAP =
    22: '传入参数格式不正确。'  # API 调用应该不会遇到
    28: '今日注册用户量已达最大值。'
    257: '创建用户失败。'  # 同上

  mod.factory 'accountAPI', ['APIv1', 'sessionAPI', (APIv1, sessionAPI) ->
    basePath = () ->
      APIv1.one 'account'

    parseStat = (data) ->
      uid: data.u
      displayName: data.n
      roles: data.r
      gender: data.g

    parseExtendedStat = (data) ->
      uid: data.u
      displayName: data.n
      displayNameMtime: new Date(data.nm * 1000)
      roles: data.r
      prefs: data.p
      email: data.e
      mobile: data.m

      identNumber: data.id
      identType: data.it

      realName: data.rn
      gender: data.g

    statAccountInternal = (uid, callback, statParserFn) ->
      basePath().one(uid).one('stat').get().then (data) ->
        retcode = data.r

        if retcode == 0
          callback retcode, statParserFn data.s
        else
          callback retcode, undefined

    # 以下为暴露 API
    errorcode: ERROR_CODE_MAP
    createAccount: (payload, callback) ->
      basePath().one('creat').customPOST(payload).then (data) ->
        retcode = data.r

        if retcode != 0
          callback retcode, data.e
        else
          callback 0, undefined

    statAccount: (uid, callback) ->
      statAccountInternal uid, callback, parseStat

    statSelf: (callback) ->
      statAccountInternal 'self', callback, parseExtendedStat
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
