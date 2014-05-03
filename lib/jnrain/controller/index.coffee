define [
  'angular'

  'jnrain/controller/nav/header'

  'jnrain/controller/debug/footer'

  'jnrain/controller/admin/index'
  'jnrain/controller/admin/vtp'

  'jnrain/controller/vtp/index'
  'jnrain/controller/vtag/index'

  'jnrain/controller/page'
  'jnrain/controller/home'
  'jnrain/controller/rtchannel'
  'jnrain/controller/register'
  'jnrain/controller/verifymail'
  'jnrain/controller/login'
  'jnrain/controller/logout'
  'jnrain/controller/authbox'
], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/controller/index', [
    'jnrain/controller/nav/header'

    'jnrain/controller/debug/footer'

    'jnrain/controller/admin/index'
    'jnrain/controller/admin/vtp'

    'jnrain/controller/vtp/index'
    'jnrain/controller/vtag/index'

    'jnrain/controller/page'
    'jnrain/controller/home'
    'jnrain/controller/rtchannel'
    'jnrain/controller/register'
    'jnrain/controller/verifymail'
    'jnrain/controller/login'
    'jnrain/controller/logout'
    'jnrain/controller/authbox'
  ]


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
