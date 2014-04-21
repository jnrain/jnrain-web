define [
  'angular',

  'jnrain/api/session'
], (angular) ->
  (app) ->
    # 注销
    app.controller 'LogoutPage', ['$scope', 'sessionAPI', ($scope, sessionAPI) ->
      $scope.inProgress = true
      $scope.retcode = -1

      sessionAPI.logout (retcode) ->
        console.log '[LogoutPage] retcode = ', retcode
        $scope.inProgress = false
        $scope.retcode = retcode

      console.log '[LogoutPage] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
