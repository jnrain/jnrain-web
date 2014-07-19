BUILD_PHASES = [
  'sass'

  'jade'
  'html2js'

  'coffeelint'
  'coffee'
  'ngmin'
  'preprocess'  # 不是笔误, 仅仅是为了在 requirejs 之前对 config 进行处理

  'requirejs'
  'copy'
]

getGruntConfig = (grunt) ->
  # LiveReload
  liveReloadOptions =
    port: 35729  # 默认端口

  sslKeyFile = grunt.option('keyfile')
  sslCertFile = grunt.option('certfile')
  if sslKeyFile? and sslCertFile?
    liveReloadOptions.key = grunt.file.read sslKeyFile
    liveReloadOptions.cert = grunt.file.read sslCertFile

  haveProductionInEnv = process.env.JNRAIN_IN_PRODUCTION?.toLowerCase() == 'true'

  # 站点配置, 将被注入 jnrain/config 模块
  siteConfigPath = grunt.option('site-config') ? 'siteconfig.yml'
  siteConfig = grunt.file.readYAML siteConfigPath

  # 配置
  PRODUCTION: grunt.option('production') or haveProductionInEnv
  SASS_OUTPUT_STYLE: '<%= PRODUCTION ? "compressed" : "nested" %>'
  sass:
    dist:
      files:
        'static/css/app.css': 'sass/app.scss'
      options:
        includePaths: [
          'bower_components/bootstrap-sass-official/vendor/assets/stylesheets'
          'bower_components/bower-bourbon'
        ]
        outputStyle: '<%= SASS_OUTPUT_STYLE >'

    vendored:
      files:
        'static/vendored/vendored.css': 'sass/vendored/vendored.scss'
      options:
        includePaths: ['./bower_components/font-awesome/scss']
        outputStyle: '<%= SASS_OUTPUT_STYLE %>'

  jade:
    ngtemplates:
      expand: true
      cwd: 'views'
      src: '**/*.tpl.jade'
      dest: 'build/templates'
      ext: '.html'

  html2js:
    ngtemplates:
      src: ['build/templates/**/*.html']
      dest: 'build/js/jnrain/ui/gen/templates.js'
      options:
        base: 'build/templates/controller'
        module: 'jnrain/ui/gen/templates'
        quoteChar: "'"
        # useStrict: true
        # Instead, toggle strict mode on the AMD module scale...
        fileHeaderString: "define(['angular'], function(angular) {\n'use strict';\n"
        fileFooterString: '});'

  coffeelint:
    all:
      expand: true
      cwd: 'lib'
      src: ['**/*.coffee']
      options:
        configFile: 'coffeelint.json'

  coffee:
    compile:
      expand: true
      cwd: 'lib'
      src: ['**/*.coffee']
      dest: 'build/coffee'
      ext: '.js'
      options:
        bare: true

  ngmin:
    all:
      expand: true
      cwd: 'build/coffee'
      src: ['**/*.js']
      dest: 'build/js'

    vendored:
      files:
        'build/js/vendored/socket.js': 'bower_components/angular-socket-io/socket.js'
        'build/js/vendored/markdown.js': 'bower_components/angular-markdown-directive/markdown.js'

  preprocess:
    config:
      files:
        'build/js/jnrain/config.js': 'build/js/jnrain/config-in.js'
      options:
        context: siteConfig

  requirejs:
    compile:
      options:
        baseUrl: 'build/js'
        mainConfigFile: 'require.config.js'

        name: '../../bower_components/almond/almond'
        include: ['entry']

        out: 'static/js/bundle.js'
        optimize: '<%= PRODUCTION ? "uglify2" : "none" %>'
        wrap: true
        useStrict: true

  watch:
    sass:
      files: ['sass/**/*.scss']
      tasks: ['sass']

    ngtemplates:
      files: ['views/**/*.tpl.jade']
      tasks: ['jade', 'html2js', 'requirejs']

    lib:
      files: ['lib/**/*.coffee', 'siteconfig.yml']
      tasks: ['coffeelint', 'coffee', 'ngmin', 'requirejs']

    misc:
      files: ['images/ready/**/*']
      tasks: ['copy']

    livereload:
      files: ['static/**/*']
      options:
        livereload: liveReloadOptions

  copy:
    'vendored-select2':
      files: [
        expand: true
        src: ['bower_components/select2/*.png', 'bower_components/select2/*.gif']
        dest: 'static/vendored/'
        flatten: true
      ]
    'vendored-fa':
      files: [
        expand: true
        src: ['bower_components/font-awesome/fonts/*']
        dest: 'static/fonts/'
        flatten: true
      ]
    'vendored-socket.io':
      files: [
        src: ['./bower_components/socket.io-client/dist/socket.io<%= PRODUCTION ? ".min" : "" %>.js']
        dest: 'static/vendored/socket.io.js'
        flatten: true
      ]
    images:
      files: [
        expand: true
        src: ['images/ready/**/*']
        dest: 'static/img/'
        flatten: true
      ]


module.exports = (grunt) ->
  grunt.initConfig getGruntConfig grunt

  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-html2js'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-ngmin'
  grunt.loadNpmTasks 'grunt-preprocess'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'default', BUILD_PHASES


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
