define [
  'jnrain/controller/debug/index',
  'jnrain/controller/register'
  'jnrain/controller/verifymail'
], (debugModules, register, verifymail) ->
  registerWith: (app) ->
    debugModules.registerWith app

    register app
    verifymail app


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
