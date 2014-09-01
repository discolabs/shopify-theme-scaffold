module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    meta: {
      banner: '// Your Theme Name\n' + '// version: <%= pkg.version %>\n' + '// author: <%= pkg.author %>\n' + '// license: <%= pkg.licenses[0].type %>\n'
    },
    less: {
      theme: {
        options: {
          compress: true
        },
        files: {
          'theme/assets/styles.min.css.liquid': 'less/styles.less'
        }
      }
    },
    shopify_theme_settings: {
      settings: {
        files: {
          'theme/config/settings.html': 'settings/*.yml'
        }
      }
    },
    copy: {
      snippets: {
        expand: true,
        cwd: 'snippets',
        src: '**/**.liquid',
        dest: 'theme/snippets',
        rename: function(dest, src) {
          var path;
          path = require('path');
          return path.join(dest, src.replace(path.sep, '-'));
        }
      },
      layout: {
        expand: true,
        cwd: 'layout',
        src: '*.liquid',
        dest: 'theme/layout'
      },
      templates: {
        expand: true,
        cwd: 'templates',
        src: '**/**.liquid',
        dest: 'theme/templates'
      },
      locales: {
        expand: true,
        cwd: 'locales',
        src: '*.json',
        dest: 'theme/locales'
      },
      assets: {
        expand: true,
        flatten: true,
        cwd: 'assets',
        src: ['**/**.css', '**/**.js', '**/**.jpg', '**/**.png', '**/**.gif', '**/**.eot', '**/**.svg', '**/**.ttf', '**/**.woff'],
        dest: 'theme/assets'
      }
    },
    compress: {
      zip: {
        options: {
          archive: 'dist/your-theme-name.zip'
        },
        files: [
          {
            expand: true,
            cwd: 'theme',
            src: ['assets/**', 'config/**', 'layout/**', 'locales/**', 'snippets/**', 'templates/**']
          }
        ]
      }
    },
    coffee: {
      gruntfile: {
        options: {
          bare: true
        },
        files: {
          'Gruntfile.js': 'Gruntfile.coffee'
        }
      }
    },
    watch: {
      less: {
        files: ['less/**/*.less'],
        tasks: ['less']
      },
      settings: {
        files: ['settings/*.yml'],
        tasks: ['shopify_theme_settings']
      },
      snippets: {
        files: ['snippets/**/**.liquid'],
        tasks: ['copy:snippets']
      },
      layout: {
        files: ['layout/*.liquid'],
        tasks: ['copy:layout']
      },
      templates: {
        files: ['templates/*.liquid'],
        tasks: ['copy:templates']
      },
      locales: {
        files: ['locales/*.json'],
        tasks: ['copy:locales']
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-shopify-theme-settings');
  grunt.registerTask('build', ['less', 'shopify_theme_settings', 'copy']);
  grunt.registerTask('dist', ['build', 'compress']);
  return grunt.registerTask('default', ['build', 'watch']);
};
