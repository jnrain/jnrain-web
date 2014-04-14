define ['angular', 'lodash', 'ui.select2', 'jnrain/api/univ', 'jnrain/api/ident'], (angular, _) ->
  (app) ->
    # 注册表单 (在读本科生)
    app.controller 'Register', ['$scope', 'univInfo', 'identAPI', ($scope, univInfo, identAPI) ->
      # 专业信息
      updateMajorsInfo = (majors) ->
        $scope.majorsInfo = majors

      # 请求本校宿舍分布信息
      updateDormInfo = (info) ->
        $scope.dormInfo = info

        # 按组团分组
        dormByGroup = _.transform info, (result, v, k) ->
          group = v.group

          if group of result
            result[group].push k
          else
            result[group] = [k]

        $scope.dormByGroup = dormByGroup
        $scope.dormGroups = _.keys dormByGroup

        # 身份信息验证逻辑
        $scope.identInfo = null
        $scope.identCheckMsg = ''
        maybeCheckIdent = () ->
          number = $scope.number
          idnumber = $scope.idnumber
          if number? and idnumber?
            doCheckIdent number, idnumber
          else
            $scope.identInfo = null
            if number?
              $scope.identCheckMsg = '请正确填写身份证后六位号码。'
            else
              if idnumber?
                $scope.identCheckMsg = '请正确填写学号。'
              else
                $scope.identCheckMsg = '请填写身份信息。'

        doCheckIdent = (number, idnumber) ->
          identAPI.queryIdent number, 0, idnumber.toUpperCase(), (retcode, data) ->
            console.log 'queryIdent returned:', retcode, data
            if retcode == 0
              $scope.identInfo = data
            else
              $scope.identInfo = null
              $scope.identCheckMsg = '' + retcode

        attrWatcher = (to, from) ->
          maybeCheckIdent()

        $scope.$watch 'number', attrWatcher
        $scope.$watch 'idnumber', attrWatcher

      univInfo.getMajorsInfo (info) ->
        updateMajorsInfo info

      univInfo.getDormsInfo (info) ->
        updateDormInfo info

      console.log $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
