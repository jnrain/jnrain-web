BUILD_PHASES = [
  'sass'

  'jade'
  'html2js'

  'coffeelint'
  'coffee'
  'ngmin'

  'requirejs'
  'copy'
]

GRUNT_CONFIG =
  sass:
    dist:
      files:
        'static/css/app.css': 'sass/app.scss'
      options:
        includePaths: [
          'bower_components/bootstrap-sass-official/vendor/assets/stylesheets'
          'bower_components/bower-bourbon'
        ]
        outputStyle: '<%= grunt.option("production") ? "compressed" : "nested" %>'

    vendored:
      files:
        'static/vendored/vendored.css': 'sass/vendored/vendored.scss'
      options:
        includePaths: ['./bower_components/font-awesome/scss']
        outputStyle: '<%= grunt.option("production") ? "compressed" : "nested" %>'

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

  requirejs:
    compile:
      options:
        baseUrl: 'build/js'
        mainConfigFile: 'require.config.js'

        name: '../../node_modules/almond/almond'
        include: ['entry']

        out: 'static/js/bundle.js'
        optimize: '<%= grunt.option("production") ? "uglify2" : "none" %>'
        wrap: true
        useStrict: true

  watch:
    sass:
      files: ['sass/**/*.scss']
      tasks: ['sass']
      options:
        livereload: true

    ngtemplates:
      files: ['views/**/*.tpl.jade']
      tasks: ['jade', 'html2js', 'requirejs']
      options:
        livereload: true

    lib:
      files: ['lib/**/*.coffee']
      tasks: ['coffeelint', 'coffee', 'ngmin', 'requirejs']
      options:
        livereload: true

    misc:
      files: ['images/ready/**/*']
      tasks: ['copy']
      options:
        livereload: true

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
        src: ['./bower_components/socket.io-client/dist/socket.io<%= grunt.option("production") ? ".min" : "" %>.js']
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
  grunt.initConfig GRUNT_CONFIG

  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-html2js'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-ngmin'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'default', BUILD_PHASES


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
