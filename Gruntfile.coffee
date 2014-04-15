BUILD_PHASES = ['sass', 'coffee', 'requirejs', 'copy']
GRUNT_CONFIG =
  sass:
    dist:
      files:
        'static/css/app.css': 'sass/app.scss'
        'static/vendored/vendored.css': 'sass/vendored.scss'
      options:
        includePaths: ['bower_components/bower-bourbon', './bower_components/font-awesome/scss']
        outputStyle: '<%= grunt.option("production") ? "compressed" : "nested" %>'

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
        optimize: '<%= grunt.option("production") ? "uglify2" : "none" %>'
        wrap: true

  watch:
    source:
      files: ['sass/**/*.scss', 'templates/**/*.jade', 'lib/**/*.coffee']
      tasks: BUILD_PHASES
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
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'default', BUILD_PHASES


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
