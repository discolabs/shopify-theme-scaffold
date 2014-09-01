Shopify Theme Scaffold
======================

This repository provides a suggested directory structure and [Grunt](http://gruntjs.com) configuration for making the Shopify theme development process as smooth as possible.
It's closely modelled on the setup used at [Disco](http://discolabs.com) when building Shopify themes.

It ships with a few sample theme files, mostly empty, that demonstrate how the scaffold works.
You should be able to slot any number of existing themes or theme frameworks in.
If you're starting off with a new theme, some of the open-source options you have are:

- [Timber](http://shopify.github.io/Timber/), Shopify's new official theme framework;
- [Skeleton Theme](https://github.com/Shopify/skeleton-theme), Shopify's older bare-bones theme framework;
- [Bootstrapify](https://github.com/luciddesign/bootstrapify), an open-source Bootstrap-based framework by Lucid Design;
- [Shopify Theme Framework](https://github.com/Cam/Shopify-Theme-Framework), an open-source Foundation-based framework by Cam Gould.

You also have (shameless plug alert) a non-open-source, paid option in the form of [Bootstrap for Shopify](http://bootstrapforshopify.com).


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

### Assets Directory (`/assets`)
Add any static assets that don't require preprocessing here - for example images, font files, third-party Javascript libraries.
Unlike Shopify's `/assets` directory, you can nest your files here in subdirectories.
Just be aware that the directory structure is flattened in the build process, so files with the same name will conflict.
This should be an issue if you use a simple nesting structure (for example, one subdirectory for each asset type).

### Layout Directory (`/layout`)
All `.liquid` files in this directory are copied directly into `/theme/layout` on compilation.

### Locales Directory (`/locales`)
All `.json` files in this directory are copied directly into `/theme/locales` on compilation.

### Settings Directory (`/settings`)
This directory can hold a number of `.yml` files, which are compiled into a `settings.html` using the `grunt-shopify-theme-settings` Grunt plugin.
See the [plugin home page](https://github.com/discolabs/grunt-shopify-theme-settings) for further usage instructions.

### Snippets Directory (`/snippets`)
Liquid files in this directory are copied into `/theme/snippets`. Unlike the standard Shopify directory layout, you can use subdirectories here.
When the theme is built, the Grunt tasks will generate filenames for your snippets based on directory path, so for example `/snippets/head/title.liquid` will be saved as `/theme/snippets/head-title.liquid`.

### Templates Directory (`/templates`)
All `.liquid` files in this directory are copied directly into `/theme/templates` on compilation. Customer templates in `/templates/customers` are copied to the corresponding directory.


## Contributions

Contributions are very much welcome! Just open a pull request, or raise an issue to discuss a proposed change.
