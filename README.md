Shopify Theme Scaffold
======================

This repository provides a suggested directory structure and [Grunt](http://gruntjs.com) configuration for making the Shopify theme development process as smooth as possible.
It's closely modelled on the setup used at [Disco](http://discolabs.com) when building Shopify themes.

It ships with a few sample theme files, mostly empty, that demonstrate how the scaffold works.
You should be able to slot any number of existing themes or theme frameworks in.
If you're starting off with a new theme, some of the open-source options you have are:

- [Timber][], Shopify's new official theme framework;
- [Skeleton Theme][], Shopify's older bare-bones theme framework;
- [Bootstrapify][], an open-source Bootstrap-based framework by Lucid Design;
- [Shopify Theme Framework][], an open-source Foundation-based framework by Cam Gould.

You also have (shameless plug alert) a non-open-source, paid option in the form of [Bootstrap for Shopify][].

[Timber]: http://shopify.github.io/Timber/
[Skeleton Theme]: https://github.com/Shopify/skeleton-theme
[Bootstrapify]: https://github.com/luciddesign/bootstrapify
[Shopify Theme Framework]: https://github.com/Cam/Shopify-Theme-Framework
[Bootstrap for Shopify]: http://bootstrapforshopify.com/?utm_source=github&utm_medium=github&utm_content=readme&utm_campaign=shopify-theme-scaffold

## Dependencies & Setup
You're going to need `nodejs` and `npm` in order to run:

```shell
npm install
```

from the base directory, which should do the rest.


## Usage

Running `grunt build` will compile all of your files into the `/theme` directory in the directory structure expected by Shopify.
You can run `grunt dist` to additionally generate a `.zip` file packaging these files up for direct upload through the Shopify Admin interface.

If you're familiar with the `shopify_theme` gem, just add your theme configuration details to a `config.yml` file in the `/theme` directory, then run `theme watch` in that directory.
Subsequent builds of your theme that alter files in the `/theme` directory will have their changes automatically uploaded to Shopify.

Here's a breakdown of the top-level directories that come with this scaffold by default.

#### Assets Directory
Add any static assets that don't require preprocessing here - for example images, font files, third-party Javascript libraries.
Unlike Shopify's `/assets` directory, you can nest your files here in subdirectories.
Just be aware that the directory structure is flattened in the build process, so files with the same name will conflict.
This shouldn't be an issue if you use a simple nesting structure (for example, one subdirectory for each asset type).

Image files (PNG, GIF, JPG and SVG) will be optimised using `grunt-contrib-imagemin` before being output to the `theme` directory.

#### Layout Directory
All `.liquid` files in `/layout` are copied directly into `/theme/layout` on compilation.

#### Locales Directory
All `.json` files in `/locales` are copied directly into `/theme/locales` on compilation.

#### Settings Directory
The `settings_schema.json` file will be copied from `/settings` to `/themes/config` on compilation.

#### Snippets Directory
Liquid files in `/snippets` are copied into `/theme/snippets`. Unlike the standard Shopify directory layout, you can use subdirectories here.
When the theme is built, the Grunt task will generate filenames for your snippets based on directory path, so for example `/snippets/head/title.liquid` will be saved as `/theme/snippets/head-title.liquid`.

When including these snippets in your template files, you'd use something like `{% include 'head-title' %}`.

#### Templates Directory
All `.liquid` files in `/templates` are copied directly into `/theme/templates` on compilation. Customer templates in `/templates/customers` are copied to the corresponding directory.


## Choosing a CSS Preprocessor
As you can see, this scaffold comes with both a `less` and `scss` directory, allowing you to use either LESS or SASS as a CSS preprocessor.
By default, the Grunt task is set up to run the SASS task.

If you'd like to use LESS instead, simply change the `build` task inside `Gruntfile.coffee` to run `newer:less` instead of `newer:sass`.


## Contributions

Contributions are very much welcome! Just open a pull request, or raise an issue to discuss a proposed change.

---

#### About the Author

[Gavin Ballard][] is a developer at [Disco][], specialising in Shopify development.
Related projects:

- [Shopify Theme Settings Grunt Plugin][]
- [Cart.js][]
- [Bootstrap for Shopify][]
- [Mastering Shopify Themes][]

[Shopify Theme Settings Grunt Plugin]: https://github.com/discolabs/grunt-shopify-theme-settings
[Cart.js]: http://cartjs.org/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Bootstrap for Shopify]: http://bootstrapforshopify.com/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Mastering Shopify Themes]: http://gavinballard.com/mastering-shopify-themes/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Gavin Ballard]: http://gavinballard.com/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
[Disco]: http://discolabs.com/?utm_source=github&utm_medium=readme&utm_campaign=shopify-theme-scaffold
