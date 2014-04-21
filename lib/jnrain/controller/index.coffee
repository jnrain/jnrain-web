define [
  'jnrain/controller/debug/index'
  'jnrain/controller/register'
  'jnrain/controller/verifymail'
  'jnrain/controller/login'
  'jnrain/controller/logout'
  'jnrain/controller/authbox'
], (debugModules, register, verifymail, login, logout, authbox) ->
  registerWith: (app) ->
    debugModules.registerWith app

    register app
    verifymail app
    login app
    logout app
    authbox app


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
