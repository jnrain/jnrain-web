define ['angular', 'lodash', 'ui.select2', 'jnrain/api/univ', 'jnrain/api/ident'], (angular, _) ->
  (app) ->
    # 注册表单 (在读本科生)
    app.controller 'Register', ['$scope', 'univInfo', 'identAPI', ($scope, univInfo, identAPI) ->
      # 最无聊的东西...
      $scope.zeropad = (x) ->
        (if x < 10 then '0' else '') + x

      # 防止重复提交
      $scope.submitInProgress = false

      # 专业信息
      updateMajorsInfo = (majors) ->
        $scope.majorsInfo = majors

      # 请求本校宿舍分布信息
      updateDormInfo = (info) ->
        $scope.dormInfo = info

        # 按性别 (主要) 与组团 (次要) 分组
        dormByGender = _.transform info, (result, v, k) ->
          group = v.group
          gender = v.gender

          if gender of result
            groupDict = result[gender]
          else
            result[gender] = {}
            groupDict = result[gender]

          if group of groupDict
            groupDict[group].push k
          else
            groupDict[group] = [k]

        $scope.dormByGender = dormByGender
        $scope.dormGroups = _.mapValues dormByGender, (v, k) ->
          _.keys v

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

      setIdentCheckValidity = (isValid) ->
        # 强制刷新控件验证结果
        $scope.registerForm.number.$setValidity 'identCheck', isValid
        $scope.registerForm.idnumber.$setValidity 'identCheck', isValid

      doCheckIdent = (number, idnumber) ->
        identAPI.queryIdent number, 0, idnumber.toUpperCase(), (retcode, data) ->
          console.log 'queryIdent returned:', retcode, data
          if retcode == 0
            $scope.identInfo = data
            setIdentCheckValidity true
          else
            $scope.identInfo = null
            $scope.identCheckMsg = identAPI.errorcode[retcode]
            setIdentCheckValidity false

      attrWatcher = (to, from) ->
        maybeCheckIdent()

      $scope.$watch 'number', attrWatcher
      $scope.$watch 'idnumber', attrWatcher

      # 表单提交
      $scope.doRegister = (sendHTMLMail) ->
        registerPayload =
          name: $scope.displayName
          pass: $scope.psw
          email: $scope.email
          mobile: $scope.mobile
          itype: 0
          inum: $scope.number
          idtype: 0
          idnum: $scope.idnumber
          iinfo:
            dorm_bldg: parseInt($scope.dormBuilding)
            dorm_room: $scope.dormRoom
          htmlmail: !!sendHTMLMail

        console.log '[registerForm] payload: ', registerPayload

      univInfo.getMajorsInfo (info) ->
        updateMajorsInfo info

      univInfo.getDormsInfo (info) ->
        updateDormInfo info

      console.log $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
