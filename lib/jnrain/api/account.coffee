define ['angular', 'lodash', 'jnrain/api/bridge'], (angular, _) ->
  mod = angular.module 'jnrain/api/account', ['jnrain/api/bridge']

  ERROR_CODE_MAP =
    22: '传入参数格式不正确。'  # API 调用应该不会遇到
    28: '今日注册用户量已达最大值。'
    257: '创建用户失败。'  # 同上

  mod.factory 'accountAPI', ['APIv1', (APIv1) ->
    errorcode: ERROR_CODE_MAP
    createAccount: (payload, callback) ->
      APIv1.one('account').one('creat').customPOST(payload).then (data) ->
        retcode = data.r

        if retcode != 0
          callback retcode, data.e
        else
          callback 0, undefined
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
