define ['angular', 'lodash', 'ui.select2', 'jnrain/univ'], (angular, _) ->
  (app) ->
    app.controller 'Foo', ['$scope', 'univInfo', ($scope, univInfo) ->
      $scope.foo = 'hello from AngularJS'

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

      univInfo.getDormsInfo (info) ->
        updateDormInfo info

      console.log $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
