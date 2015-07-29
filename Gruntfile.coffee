module.exports = (grunt) ->

  # Flags from command line options.
  IS_PRODUCTION = (grunt.option('env') == 'production')

  # Define patterns used to match image-based assets (for ImageMin) and other types of asset.
  IMAGE_ASSET_PATTERN = '**/*.{png,jpg,jpeg,gif,svg}'
  OTHER_ASSET_PATTERN = '**/*.{css,js,scss,css.liquid,js.liquid,scss.liquid,eot,ttf,woff}'

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
      theme:
        options:
          style: if IS_PRODUCTION then 'compressed' else 'expanded'
          sourcemap: not IS_PRODUCTION
        files:
          'theme/assets/styles.css.liquid': 'scss/styles.scss'

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
          cwd: 'assets',
          src: [IMAGE_ASSET_PATTERN],
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
        src: [OTHER_ASSET_PATTERN]
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
      sass:
        files: ['scss/**/*.scss']
        tasks: ['newer:sass']
      copy:
        files: [
          'layout/*.liquid',
          'locales/*.json',
          'settings/settings_schema.json',
          'snippets/*.liquid',
          'templates/**/*.liquid',
          'assets/' + OTHER_ASSET_PATTERN
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
  grunt.registerTask 'build',   ['newer:sass', 'newer:imagemin', 'newer:copy']
  grunt.registerTask 'dist',    ['build', 'compress']
  grunt.registerTask 'default', ['build', 'watch']
