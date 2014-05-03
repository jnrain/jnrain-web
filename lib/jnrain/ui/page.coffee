define [
  'angular'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/ui/page', [
  ]

  # 网页全局设置
  mod.factory 'PageGlobals',
    ($rootScope, $log) ->
      $log = $log.getInstance 'ui/page'

      # The improved breadcrumb nav implementation here is inspired by this
      # detailed SO answer:
      # http://stackoverflow.com/a/22263990/596531
      titleFrags = []

      # 按逆序构造状态碎片列表 (从内层到外层状态)
      # stateCurrent 是 state.$current
      constructTitleFrags = (stateCurrent, accumulator) ->
        # 尝试解出 resolve 中的 navData
        navData = stateCurrent.locals.globals.navData
        shouldOmitState = false

        if navData?
          # 处理忽略本层状态的情况 (默认不会忽略)
          shouldOmitState = navData.omit

          # 取出标题
          currentTitleFrag = navData.title
          if !currentTitleFrag?
            # 没有指定标题, fallback 到空标题
            currentTitleFrag = ''
        else
          # 没有配置导航, 同样 fallback 到空标题
          # 为何没有处理成忽略本层状态, 而是选择返回一个空字符串的状态名?
          # 这是考虑到方便调试各种编程疏漏的原因, 故意造成的异常状态.
          currentTitleFrag = ''

        unless shouldOmitState
          accumulator.push currentTitleFrag

        # 如果有 parent 状态就递归
        # 但如果有设置 navData.root 的话就在这里结束
        if stateCurrent.parent? and !navData?.root
          constructTitleFrags stateCurrent.parent, accumulator
        else
          # 递归终止
          accumulator

      titleFragsFromState = (state) ->
        constructTitleFrags state.$current, []

      getTitleFrags = () ->
        titleFrags

      updateState = (state) ->
        $log.debug 'updateState: state=', state
        titleFrags = titleFragsFromState state

      # 暴露 API
      getTitleFrags: getTitleFrags
      updateState: updateState


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
