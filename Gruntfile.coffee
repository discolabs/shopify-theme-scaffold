module.exports = (grunt) ->

  # Flags from command line options.
  IS_PRODUCTION = (grunt.option('env') == 'production')

  # Define patterns used to match image-based assets (for ImageMin) and other types of asset.
  IMAGE_ASSET_PATTERN = '**/*.{png,jpg,jpeg,gif,svg}'
  STATIC_ASSETS_PATTERN = '**/*.{css,js,scss,css.liquid,js.liquid,scss.liquid,eot,ttf,woff}'

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

    # Compilation of SCSS files to compressed .css.liquid files.
    sass:
      options:
          style: if IS_PRODUCTION then 'compressed' else 'expanded'
          sourcemap: not IS_PRODUCTION
      theme:
        files:
          '.build/assets/styles.css.liquid': 'theme/assets/scss/styles.scss'

    # Concatenation and minification of Javascript.
    uglify:
      options:
        compress: IS_PRODUCTION
        mangle: IS_PRODUCTION
        beautify: not IS_PRODUCTION
        sourceMap: not IS_PRODUCTION
      theme:
        files:
          '.build/assets/script.js.liquid': ['theme/assets/js/script-*.js']

    # Optimisation of image assets.
    imagemin:
      options:
        optimizationLevel: if IS_PRODUCTION then 7 else 0
        progressive: IS_PRODUCTION
        interlaced: IS_PRODUCTION
      assets:
        files: [{
          expand: true,
          flatten: true,
          cwd: 'theme/assets/static',
          src: [IMAGE_ASSET_PATTERN],
          dest: '.build/assets'
        }]

    # Copying of various theme files.
    copy:
      layout:
        expand: true
        cwd: 'theme/layout'
        src: '*.liquid'
        dest: '.build/layout'
      templates:
        expand: true
        cwd: 'theme/templates'
        src: '**/**.liquid'
        dest: '.build/templates'
      settings:
        expand: true
        cwd: 'theme/settings'
        src: 'settings_schema.json'
        dest: '.build/config'
      snippets:
        expand: true
        cwd: 'theme/snippets'
        src: '*.liquid'
        dest: '.build/snippets'
      locales:
        expand: true
        cwd: 'theme/locales'
        src: '*.json'
        dest: '.build/locales'
      assets:
        expand: true
        flatten: true
        cwd: 'theme/assets/static'
        src: [STATIC_ASSETS_PATTERN]
        dest: '.build/assets'

    # Compression to a .zip for direct upload to Shopify Admin.
    compress:
      zip:
        options:
          archive: 'dist/your-theme-name.zip'
        files: [
          expand: true
          cwd: '.build'
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
    clean: ['dist', '.build/assets', '.build/config', '.build/layout', '.build/locales', '.build/snippets', '.build/templates']

    # Watch task.
    watch:
      sass:
        files: ['theme/assets/scss/**/*.scss']
        tasks: ['newer:sass']
      uglify:
        files: ['theme/assets/js/**/*.js']
        tasks: ['newer:uglify']
      imagemin:
        files: ['theme/assets/static/' + IMAGE_ASSET_PATTERN]
        tasks: ['newer:imagemin']
      copy:
        files: [
          'theme/layout/*.liquid',
          'theme/locales/*.json',
          'theme/settings/settings_schema.json',
          'theme/snippets/*.liquid',
          'theme/templates/**/*.liquid',
          'theme/assets/static/' + STATIC_ASSETS_PATTERN
        ]
        tasks: ['newer:copy']

  # Production-specific configuration.
  if IS_PRODUCTION
    grunt.config 'newer'
      options:
        override: (detail, include) ->
          include(true)

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
  grunt.registerTask 'build',   ['newer:sass', 'newer:uglify', 'newer:imagemin', 'newer:copy']
  grunt.registerTask 'dist',    ['build', 'compress']
  grunt.registerTask 'default', ['build', 'watch']
