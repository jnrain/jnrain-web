define ['angular', 'jnrain/univ'], (angular) ->
  (app) ->
    app.controller 'Foo', ['$scope', 'univInfo', ($scope, univInfo) ->
      $scope.foo = 'hello from AngularJS'
      univInfo.getBasicInfo (info) ->
        console.log info
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
