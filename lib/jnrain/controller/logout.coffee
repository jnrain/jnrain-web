define [
  'angular',

  'jnrain/api/session'
  'jnrain/ui/toasts'
], (angular) ->
  (app) ->
    # 注销
    app.controller 'LogoutPage', [
      '$scope'
      'sessionAPI'
      'Toasts'
      ($scope, sessionAPI, Toasts) ->
        $scope.inProgress = true
        $scope.retcode = -1

        sessionAPI.logout (retcode) ->
          console.log '[LogoutPage] retcode = ', retcode
          $scope.inProgress = false
          $scope.retcode = retcode

          Toasts.toast 'info', '注销成功', '您已成功注销。'

        console.log '[LogoutPage] $scope = ', $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
