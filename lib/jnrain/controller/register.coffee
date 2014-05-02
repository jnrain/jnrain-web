define [
  'angular'
  'jsSHA'
  'ui.select2'
  'angular-ui-router'

  'jnrain/api/account'
  'jnrain/api/ident'
  'jnrain/provider/univ'
  'jnrain/ui/modal'
], (angular, jsSHA) ->
  'use strict'

  mod = angular.module 'jnrain/controller/register', [
    'ui.router'
    'jnrain/api/account'
    'jnrain/api/ident'
    'jnrain/provider/univ'
    'jnrain/ui/modal'
  ]

  # 注册表单 (在读本科生)
  # NOTE: 这个过程实质上是注册, 但在用户界面上应统一使用 "激活" 的说法.
  # 造成一种注册很容易的感觉 (实际上比之前要容易多了, 但因为实名制的原因不可能
  # 做到比各种商业网站还容易, 因此需要玩一点文字游戏)
  mod.controller 'RegisterPage',
    ($scope, $state, $log, ModalDlg, UnivInfo, AccountAPI, IdentAPI) ->
      $log = $log.getInstance 'RegisterPage'

      # 最无聊的东西...
      $scope.zeropad = (x) ->
        (if x < 10 then '0' else '') + x

      # 防止重复提交
      $scope.submitInProgress = false

      # 成功提交后跳转
      doSuccessRedirect = () ->
        # 首页
        $state.go 'home'

      # 大学信息
      $scope.$on 'provider:univInfoRefreshed', (evt) ->
        $scope.majorsInfo = UnivInfo.majorsInfo()
        $scope.dormsByGender = UnivInfo.dormsByGender()
        $scope.dormGroups = UnivInfo.dormGroups()

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
        IdentAPI.queryIdent number, 0, normIDNumber, (retcode, data) ->
          $log.info 'queryIdent returned: ', retcode, data
          if retcode == 0
            $scope.identInfo = data
            setIdentCheckValidity true
          else
            $scope.identInfo = null
            $scope.identCheckMsg = IdentAPI.errorcode[retcode]
            setIdentCheckValidity false

      attrWatcher = (to, from) ->
        maybeCheckIdent()

      $scope.$watch 'number', attrWatcher
      $scope.$watch 'idnumber', attrWatcher

      # 模态弹层
      showModal = (title, message, callback, dismissCallback) ->
        options =
          templateUrl: 'registerResponseDlg.html'
          controller: 'RegisterResponseDlg'
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

        $log.debug 'payload: ', registerPayload
        AccountAPI.createAccount registerPayload, (retcode, err) ->
          $scope.submitInProgress = false

          if retcode == 0
            $log.info 'submit: OK'
            showModal(
              '提交激活成功',
              '您很快将收到一封验证邮件，请登录您的注册邮箱查收；'
              '现在页面将跳转回首页。',
              doSuccessRedirect,
              doSuccessRedirect,
            )
          else
            $log.warn(
              'submit: failed, retcode=',
              retcode,
              ', err=',
              err,
            )

            # 生成错误信息
            retcodeMsg = AccountAPI.errorcode[retcode]
            if retcode == 257
              # TODO: 整理用户/实名身份组件的错误码对应信息
              userErrorMsg = '' + err
              errorMessage = retcodeMsg + '\n错误信息：' + userErrorMsg
            else
              errorMessage = retcodeMsg

            showModal '激活遇到问题', errorMessage

      # 请求大学信息
      UnivInfo.maybeRefresh()

      $log.debug '$scope = ', $scope

  # 模态弹层
  mod.controller 'RegisterResponseDlg',
    ($scope, $modalInstance, title, message) ->
      $scope.title = title
      $scope.message = message

      $scope.ok = () ->
        $modalInstance.close()

  mod.config ($stateProvider) ->
    $stateProvider.state 'register',
      url: '/register'
      data:
        title: '激活帐号'
      views:
        main:
          templateUrl: 'register.html'


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
