Shopify Theme Scaffold
======================
This repository provides a suggested directory structure and [Grunt][]
configuration for making the Shopify theme development process as smooth as
possible. It's closely modelled on the setup used at [Disco][] when building
Shopify themes.

It ships with a few sample theme files, mostly empty, that demonstrate how the
scaffold works. You should be able to slot any number of existing themes or
theme frameworks in. If you're starting off with a new theme, some of the
open-source options you have are:

- [Timber][], Shopify's new official theme framework;
- [Skeleton Theme][], Shopify's older bare-bones theme framework;
- [Bootstrapify][], an open-source Bootstrap-based framework by Lucid Design;
- [Shopify Theme Framework][], an open-source Foundation-based framework by Cam Gould.

You also have (shameless plug alert) a non-open-source, paid option in the form of [Bootstrap for Shopify][].

[Disco]: https://www.discolabs.com
[Grunt]: http://gruntjs.com
[Timber]: http://shopify.github.io/Timber/
[Skeleton Theme]: https://github.com/Shopify/skeleton-theme
[Bootstrapify]: https://github.com/luciddesign/bootstrapify
[Shopify Theme Framework]: https://github.com/Cam/Shopify-Theme-Framework
[Bootstrap for Shopify]: http://bootstrapforshopify.com/?utm_source=github&utm_medium=github&utm_content=readme&utm_campaign=shopify-theme-scaffold


## Dependencies and Setup
You're going to need `nodejs` and `npm` in order to run:

```shell
npm install
```

from the base directory, which should do the rest.


## Development Builds
Running `grunt build` will compile all of your files into the `.build`
directory in the directory structure expected by Shopify. You can run
`grunt dist` to additionally generate a `.zip` file, packaging these files up
for direct upload through the Shopify Admin interface.

If you're familiar with the `shopify_theme` gem, just add your theme
configuration details to a `config.yml` file in the `.build` directory, then
run `theme watch` in that directory. Subsequent builds of your theme that alter
files in the `theme` directory will have their changes automatically uploaded
to Shopify.

Instead of running `grunt build` every time you want to rebuild your theme, you
can use the `grunt watch` command to start a process watching all of your files
for changes. The `watch` command has plenty of smarts to avoid recompiling your
entire theme every time a single file changes.


## Production Builds
The standard `grunt build` command assumes a development environment, meaning
the built theme is optimised for fast iteration and easy debugging. To build a
"production" version of your theme, with minified assets and optimised images,
run `grunt build --env=production`.

We highly recommend using [DeployBot][] to deploy Shopify themes in production.
Their new build server functionality is a perfect match for a Grunt-driven
theme build process.

[DeployBot]: https://deploybot.com


## Directory Structure

Here's a breakdown of the default directory structure that ships with the
scaffold:

#### theme/assets/js
Any Javascript files you'd like concatenated and (in production) minified
should go in here.

For each final script file you'd like to use in your theme, set up an Uglify
`files` target in `Gruntfile.coffee` like this:

```js
# Concatenation and minification of Javascript.
uglify:
  options:
    ... some options ...
  js:
    files:
      '.build/assets/script.js.liquid': ['theme/assets/js/script-*.js']
```

#### theme/assets/scss
Any stylesheets you'd like to be precompiled and (in production) minified
should go in here.

For each final stylesheet file you'd like to use in your theme, set up a Sass
`files` target in `Gruntfile.coffee` like this:

```js
# Compilation of SCSS files to compressed .css.liquid files.
sass:
  options:
    ... some options ...
  theme:
    files:
      '.build/assets/styles.css.liquid': 'theme/assets/scss/styles.scss'
```

#### theme/assets/static
Add any static assets that don't require preprocessing here - for example
images, font files, and pre-minified third-party Javascript libraries. Unlike
Shopify's `/assets` directory, you can nest your files here in subdirectories.
Just be aware that the directory structure is flattened in the build process,
so files with the same name will conflict. This shouldn't be an issue if you
use a simple nesting structure (for example, one subdirectory for each asset
type).

Image files (PNG, GIF, JPG and SVG) will be optimised using
`grunt-contrib-imagemin` before being output to the `.build` directory.

#### theme/layout
All `.liquid` files in `theme/layout` are copied directly into
`.build/layout` on compilation.

#### theme/locales
All `.json` files in `theme/locales` are copied directly into `.build/locales`
on compilation.

#### theme/settings
The `settings_schema.json` file will be copied from `theme/settings` to
`.build/config` on compilation.

#### theme/snippets
All `.liquid` files in `theme/snippets` are copied directly into
`.build/templates` on compilation.

#### theme/templates
All `.liquid` files in `theme/templates` are copied directly into
`.build/templates` on compilation. Customer templates in
`theme/templates/customers` are copied to `.build/templates/customers`.


## Contributions
Contributions are very much welcome! Just open a pull request, or raise an
issue to discuss a proposed change.

---

#### About the Author

[Gavin Ballard][] is a developer at [Disco][], specialising in Shopify
development. Related projects:

- [Cart.js][]
- [Bootstrap for Shopify][]
- [Mastering Shopify Themes][]

[Cart.js]: http://cartjs.org/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Bootstrap for Shopify]: http://bootstrapforshopify.com/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Mastering Shopify Themes]: http://gavinballard.com/mastering-shopify-themes/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Gavin Ballard]: http://gavinballard.com/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Disco]: http://discolabs.com/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
