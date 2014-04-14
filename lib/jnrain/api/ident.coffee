define ['angular', 'lodash', 'jnrain/api/bridge'], (angular, _) ->
  mod = angular.module 'jnrain/api/ident', ['jnrain/api/bridge']

  mod.factory 'identAPI', ['APIv1', (APIv1) ->
    queryIdent: (number, idType, idNum, callback) ->
      APIv1.one('account').one('ident').one('query').customPOST(
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
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
