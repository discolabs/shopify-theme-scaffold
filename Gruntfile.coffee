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

    # Compilation of SCSS files to compressed .css.liquid files.
    sass:
      theme:
        options:
          style: 'compressed'
        files:
          'theme/assets/styles.min.css.liquid': 'scss/styles.scss'

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
      settings:
        expand: true
        cwd: 'settings'
        src: 'settings_schema.json'
        dest: 'theme/config'
      snippets:
        expand: true
        cwd: 'snippets'
        src: '*.liquid'
        dest: 'theme/snippets'
      locales:
        expand: true
        cwd: 'locales'
        src: '*.json'
        dest: 'theme/locales'
      assets:
        expand: true
        flatten: true
        cwd: 'assets'
        src: ['**/*.{css,js,scss,css.liquid,js.liquid,scss.liquid,eot,ttf,woff}']
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

    # Clean up generated files.
    clean: ['dist', 'theme/assets', 'theme/config', 'theme/layout', 'theme/locales', 'theme/snippets', 'theme/templates']

    # Watch task.
    watch:
      less:
        files: ['less/**/*.less']
        tasks: ['less']
      settings:
        files: ['settings/settings_schema.json']
        tasks: ['copy:settings']
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
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-newer'

  # Register tasks made available through the Gruntfile.
  grunt.registerTask 'build',   ['newer:sass', 'newer:imagemin', 'newer:copy']
  grunt.registerTask 'dist',    ['build', 'compress']
  grunt.registerTask 'default', ['build', 'watch']
