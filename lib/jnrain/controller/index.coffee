define [
  'jnrain/controller/debug/index',
  'jnrain/controller/register'
], (debugModules, register) ->
  registerWith: (app) ->
    debugModules.registerWith app

    register app


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
