define [
  'angular',
  'lodash',

  'jnrain/api/ident'
], (angular, _) ->
  (app) ->
    # 邮箱验证
    app.controller 'VerifyMail', ['$scope', 'identAPI', ($scope, identAPI) ->
      $scope.inProgress = true
      $scope.retcode = -1

      # 从页面中解出 activationKey
      getActivationKey = () ->
        angular.element('#activation-key').text().trim()
      $scope.activationKey = getActivationKey()

      # 进行 API 请求
      identAPI.verifyMail $scope.activationKey, (retcode) ->
        console.log '[VerifyMail] retcode = ', retcode
        $scope.inProgress = false
        $scope.retcode = retcode

      console.log '[VerifyMail] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
