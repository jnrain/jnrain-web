define [
  'angular'
  'lodash'
  'angular-local-storage'

  'jnrain/api/univ'
], (angular, _) ->
  'use strict'

  mod = angular.module 'jnrain/provider/univ', [
    'LocalStorageModule'
    'jnrain/api/univ'
  ]

  mod.factory 'UnivInfo',
    ($rootScope, $log, UnivAPI, localStorageService) ->
      # TODO: 移动到 jnrain/config
      # 大学信息刷新时间间隔, 单位: 毫秒
      univRefreshInterval = 30 * 86400 * 1000  # 30 d

      getLastRefreshTime = () ->
        localStorageService.get 'univLastRefreshed'

      univInfo = (value) ->
        if value?
          localStorageService.set 'univLastRefreshed', +new Date()
          localStorageService.set 'univInfo', value
        else
          localStorageService.get 'univInfo'

      # 专业信息
      majorsInfo = () ->
        univInfo().majors

      # 宿舍分布信息
      dormsInfo = () ->
        univInfo().dorms.info

      dormsByGender = () ->
        univInfo().dorms.byGender

      dormGroups = () ->
        univInfo().dorms.groups

      # 宿舍信息预处理
      processDormInfo = (info) ->
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

        dormGroups = _.mapValues dormByGender, (v, k) ->
          _.keys v

        # 返回
        info: info
        byGender: dormByGender
        groups: dormGroups

      shouldRefresh = () ->
        now = +new Date()
        lastRefreshed = getLastRefreshTime()

        !lastRefreshed? or now - lastRefreshed > univRefreshInterval

      doRefresh = () ->
        UnivAPI.getMajorsInfo (majorsData) ->
          $log.info '[provider/univ] majors info retrieved: ', majorsData

          UnivAPI.getDormsInfo (dormsData) ->
            $log.info '[provider/univ] dorms info retrieved: ', dormsData

            dormsInfoProcessed = processDormInfo dormsData

            # 写浏览器存储
            univInfo
              majors: majorsData
              dorms: dormsInfoProcessed

            # 通知
            $rootScope.$broadcast 'provider:univInfoRefreshed'

      maybeRefresh = () ->
        if shouldRefresh()
          doRefresh()
        else
          $rootScope.$broadcast 'provider:univInfoRefreshed'

      # 暴露 API
      getLastRefreshTime: getLastRefreshTime
      shouldRefresh: shouldRefresh
      maybeRefresh: maybeRefresh
      forceRefresh: doRefresh
      majorsInfo: majorsInfo
      dormsInfo: dormsInfo
      dormsByGender: dormsByGender
      dormGroups: dormGroups


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
