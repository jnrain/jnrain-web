GRUNT_CONFIG =
  sass:
    dist:
      files:
        'static/css/skel.css': 'sass/skel.scss'
  watch:
    source:
      files: ['sass/**/*.scss', 'templates/**/*.jade']
      tasks: ['sass']
      options:
        livereload: true


module.exports = (grunt) ->
  grunt.initConfig GRUNT_CONFIG

  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['sass']


# vim:set ai et ts=2 sw=2 sts=2 fenc=utf-8:
