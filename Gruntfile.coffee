BUILD_PHASES = ['sass', 'coffee', 'requirejs']
GRUNT_CONFIG =
  sass:
    dist:
      files:
        'static/css/skel.css': 'sass/skel.scss'
      options:
        includePaths: ['bower_components/bower-bourbon']
        outputStyle: 'compressed'

  coffee:
    compile:
      expand: true
      cwd: 'lib'
      src: ['**/*.coffee']
      dest: 'build/js'
      ext: '.js'
      options:
        bare: true

  requirejs:
    compile:
      options:
        baseUrl: 'build/js'
        mainConfigFile: 'require.config.js'

        name: '../../node_modules/almond/almond'
        include: ['entry']

        out: 'static/js/bundle.js'
        optimize: 'none'
        wrap: true

  watch:
    source:
      files: ['sass/**/*.scss', 'templates/**/*.jade']
      tasks: BUILD_PHASES
      options:
        livereload: true


module.exports = (grunt) ->
  grunt.initConfig GRUNT_CONFIG

  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', BUILD_PHASES


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
