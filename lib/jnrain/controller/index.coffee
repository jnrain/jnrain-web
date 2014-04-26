define [
  'jnrain/controller/nav/index'
  'jnrain/controller/debug/index'
  'jnrain/controller/rtchannel'
  'jnrain/controller/register'
  'jnrain/controller/verifymail'
  'jnrain/controller/login'
  'jnrain/controller/logout'
  'jnrain/controller/authbox'
], (
  navModules,
  debugModules,
  rtchannel,
  register,
  verifymail,
  login,
  logout,
  authbox,
) ->
  'use strict'

  registerWith: (app) ->
    navModules.registerWith app
    debugModules.registerWith app

    rtchannel app
    register app
    verifymail app
    login app
    logout app
    authbox app


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
