define ['angular', 'lodash', 'jnrain/api/bridge'], (angular, _) ->
  mod = angular.module 'jnrain/api/ident', ['jnrain/api/bridge']

  ERROR_CODE_MAP =
    2: '没有找到指定的学号。'
    13: '信息不匹配，身份验证失败。'
    17: '指定的学号已经注册过帐号。'
    22: '传入参数格式不正确。'  # API 调用应该不会遇到
    257: '身份信息格式不正确。'  # 同上

  mod.factory 'identAPI', ['APIv1', (APIv1) ->
    basePath = () ->
      APIv1.one('account').one('ident')

    errorcode: ERROR_CODE_MAP
    queryIdent: (number, idType, idNum, callback) ->
      basePath().one('query').customPOST(
        number: number
        idtype: idType
        idnum: idNum
      ).then (data) ->
        retcode = data.r

        if retcode != 0
          callback retcode, undefined
        else
          result =
            type: data.t
            name: data.n
            gender: data.g
            school: data.ss
            major: data.sm
            klass: data.sc
            year: data.sy

          callback 0, result

    verifyMail: (activationKey, callback) ->
      basePath().one('activate').customPOST(
        activation_key: activationKey
      ).then (data) ->
        retcode = data.r
        callback retcode
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
