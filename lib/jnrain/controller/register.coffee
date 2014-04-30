define [
  'angular'
  'lodash'
  'jsSHA'
  'ui.select2'
  'angular-ui-router'

  'jnrain/api/univ'
  'jnrain/api/account'
  'jnrain/api/ident'
  'jnrain/ui/modal'
], (angular, _, jsSHA) ->
  'use strict'

  mod = angular.module 'jnrain/controller/register', [
    'ui.router'
    'jnrain/api/univ'
    'jnrain/api/account'
    'jnrain/api/ident'
    'jnrain/ui/modal'
  ]

  # 注册表单 (在读本科生)
  mod.controller 'Register',
    ($scope, $state, ModalDlg, univInfo, accountAPI, identAPI) ->
      # 最无聊的东西...
      $scope.zeropad = (x) ->
        (if x < 10 then '0' else '') + x

      # 防止重复提交
      $scope.submitInProgress = false

      # 成功提交后跳转
      doSuccessRedirect = () ->
        # 首页
        $state.go 'home'

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
        normIDNumber = idnumber.toUpperCase()
        identAPI.queryIdent number, 0, normIDNumber, (retcode, data) ->
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

      # 模态弹层
      showModal = (title, message, callback, dismissCallback) ->
        options =
          templateUrl: 'modalContent.html'
          controller: RegisterFormModalInstance
          resolve:
            title: () ->
              title
            message: () ->
              message

        ModalDlg.show options, callback, dismissCallback

      # 表单提交
      $scope.doRegister = (sendHTMLMail) ->
        $scope.submitInProgress = true

        registerPayload =
          name: $scope.displayName
          pass: new jsSHA($scope.psw, 'TEXT').getHash 'SHA-512', 'HEX'
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
        accountAPI.createAccount registerPayload, (retcode, err) ->
          $scope.submitInProgress = false

          if retcode == 0
            console.log '[registerForm] submit: OK'
            showModal(
              '提交成功',
              '您很快将收到一封验证邮件，请登陆您的注册邮箱查收；'
              '现在页面将跳转回首页。',
              doSuccessRedirect,
              doSuccessRedirect,
            )
          else
            console.log '[registerForm] submit: retcode = ', retcode
            console.log '[registerForm] submit: err = ', err

            # 生成错误信息
            retcodeMsg = accountAPI.errorcode[retcode]
            if retcode == 257
              # TODO: 整理用户/实名身份组件的错误码对应信息
              userErrorMsg = '' + err
              errorMessage = retcodeMsg + '\n错误信息：' + userErrorMsg
            else
              errorMessage = retcodeMsg

            showModal '注册遇到问题', errorMessage

      univInfo.getMajorsInfo (info) ->
        updateMajorsInfo info

      univInfo.getDormsInfo (info) ->
        updateDormInfo info

      console.log $scope

  mod.config ($stateProvider) ->
    $stateProvider.state 'register',
      url: '/register'
      data:
        title: '新用户注册'
      views:
        main:
          templateUrl: 'register.html'

  # 模态弹层
  RegisterFormModalInstance = ($scope, $modalInstance, title, message) ->
    $scope.title = title
    $scope.message = message

    $scope.ok = () ->
      $modalInstance.close()

  RegisterFormModalInstance.$inject = [
    '$scope'
    '$modalInstance'
    'title'
    'message'
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
