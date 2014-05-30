define ['angular'], (angular) ->
  'use strict'

  mod = angular.module 'jnrain/config', []

  mod.constant 'apiDomain', '/* @echo apiDomain */'
  mod.constant 'rtDomain', '/* @echo rtDomain */'
  mod.constant(
    'sessionRefreshInterval',
    parseInt('/* @echo sessionRefreshInterval */'),
  )


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
