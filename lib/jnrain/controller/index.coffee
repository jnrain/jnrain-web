define [
  'jnrain/controller/debug/index'
  'jnrain/controller/register'
  'jnrain/controller/verifymail'
  'jnrain/controller/login'
  'jnrain/controller/authbox'
], (debugModules, register, verifymail, login, authbox) ->
  registerWith: (app) ->
    debugModules.registerWith app

    register app
    verifymail app
    login app
    authbox app


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
