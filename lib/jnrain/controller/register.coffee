define ['angular', 'lodash', 'ui.select2', 'jnrain/api/univ', 'jnrain/api/ident'], (angular, _) ->
  (app) ->
    # 验证工具
    app.directive 'identValidate', () ->
      restrict: 'A'
      require: 'ngModel'
      link: (scope, elem, attr, ctrl) ->
        watcherFn = (newArr, oldArr) ->
          0

        scope.$watch attr.identValidate, watcherFn, true

    # 注册表单 (在读本科生)
    app.controller 'Register', ['$scope', 'univInfo', 'identAPI', ($scope, univInfo, identAPI) ->
      # TODO: 实名验证机制

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

      univInfo.getDormsInfo (info) ->
        updateDormInfo info

      console.log $scope
    ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
