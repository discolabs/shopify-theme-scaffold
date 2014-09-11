module.exports = (grunt) ->

  # Initialise the Grunt config.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    # Meta information about theme.
    meta:
      banner:
        '// Your Theme Name\n' +
        '// version: <%= pkg.version %>\n' +
        '// author: <%= pkg.author %>\n' +
        '// license: <%= pkg.licenses[0].type %>\n'

    # Compilation of LESS files to compressed .css.liquid files.
    less:
      theme:
        options:
          compress: true
        files:
          'theme/assets/styles.min.css.liquid': 'less/styles.less'

    # Compilation of theme settings from YAML files.
    shopify_theme_settings:
      settings:
        files:
          'theme/config/settings.html': 'settings/*.yml'

    # Optimisation of image assets.
    imagemin:
      assets:
        files: [{
          expand: true,
          flatten: true,
          cwd: 'assets',
          src: ['**/*.{png,jpg,jpeg,gif,svg}'],
          dest: 'theme/assets'
        }]

    # Copying of various theme files.
    copy:
      snippets:
        expand: true
        cwd: 'snippets'
        src: '**/**.liquid'
        dest: 'theme/snippets'
        rename: (dest, src)->
          path = require('path')
          path.join(dest, src.replace(path.sep, '-'))
      layout:
        expand: true
        cwd: 'layout'
        src: '*.liquid'
        dest: 'theme/layout'
      templates:
        expand: true
        cwd: 'templates'
        src: '**/**.liquid'
        dest: 'theme/templates'
      locales:
        expand: true
        cwd: 'locales'
        src: '*.json'
        dest: 'theme/locales'
      assets:
        expand: true
        flatten: true
        cwd: 'assets'
        src: ['**/*.{css,js,eot,ttf,woff}']
        dest: 'theme/assets'

    # Compression to a .zip for direct upload to Shopify Admin.
    compress:
      zip:
        options:
          archive: 'dist/your-theme-name.zip'
        files: [
          expand: true
          cwd: 'theme'
          src: [
            'assets/**',
            'config/**',
            'layout/**',
            'locales/**',
            'snippets/**',
            'templates/**'
          ]
        ]

    # Compilation of this Gruntfile to plain .js for those who prefer it.
    coffee:
      gruntfile:
        options:
          bare: true
        files:
          'Gruntfile.js': 'Gruntfile.coffee'

    # Clean up generated files.
    clean: ['dist', 'theme/assets', 'theme/config', 'theme/layout', 'theme/locales', 'theme/snippets', 'theme/templates']

    # Watch task.
    watch:
      less:
        files: ['less/**/*.less']
        tasks: ['less']
      settings:
        files: ['settings/*.yml']
        tasks: ['shopify_theme_settings']
      snippets:
        files: ['snippets/**/**.liquid']
        tasks: ['copy:snippets']
      layout:
        files: ['layout/*.liquid']
        tasks: ['copy:layout']
      templates:
        files: ['templates/*.liquid']
        tasks: ['copy:templates']
      locales:
        files: ['locales/*.json']
        tasks: ['copy:locales']

  # Load tasks made available through NPM.
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-shopify-theme-settings'

  # Register tasks made available through the Gruntfile.
  grunt.registerTask 'build',   ['newer:less', 'newer:shopify_theme_settings', 'newer:imagemin', 'newer:copy']
  grunt.registerTask 'dist',    ['build', 'compress']
  grunt.registerTask 'default', ['build', 'watch']
