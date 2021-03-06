Pangolin Notebook<img width="280px" title="Illustration of Pangolin by Joseph Wolf, 1865, Proceedings of the Zoological Society of London" align="right" src=".graphics/pangolin-sm.jpg">
================

Pangolin Notebook is a simple static site generator for creating a notebook written using [Pandoc](https://pandoc.org)-flavored [Markdown](https://pandoc.org/MANUAL.html), with citations, mathematics, auto-generation of previews, and hosting with [GitHub Pages](https://pages.github.com).

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Latest version](https://img.shields.io/badge/Latest_version-1.3.0-green.svg?style=flat-square)](https://github.com/mhucka/pangolin-notebook/releases)
[![Stability](https://img.shields.io/badge/stability-experimental-orange.svg?style=flat-square)](http://shields.io)

*Author*:      [Michael Hucka](http://github.com/mhucka)<br>
*Repository*:   [https://github.com/mhucka/pangolin-notebook](https://github.com/mhucka/pangolin-notebook)<br>
*License*:      Unless otherwise noted, this content is licensed under the [MIT License](https://opensource.org/licenses/MIT).

Table of contents
-----------------

* [Introduction](#-introduction)
* [Installing Pangolin Notebook](#-installing-pangolin-notebook)
* [Using Pangolin Notebook](#-using-pangolin-notebook)
* [Getting help and support](#-getting-help-and-support)
* [Contributing — info for developers](#-contributing--info-for-developers)
* [Copyright and license](#-copyright-and-license)
* [Acknowledgments](#-acknowledgments)

✺ Introduction
-------------

Pangolin Notebook grew out of a desire for a simple way to write a collection of documents, with the following criteria:

* write in plain text using a simple notation such as Markdown
* include citations, with references stored in BibTeX format
* include mathematics written in TeX notation
* auto-generate previews while editing on a local computer
* use GitHub Pages to host the formatted results
* use GitHub to store the source files and allow collaboration with other people

There exist other, similar systems, but I encountered a limitation or source of frustration in every one I tried.  Ultimately, I was led to create Pangolin Notebook.  Admittedly, it's another variation on a common theme, but if you're looking for the same features, maybe this particular formulation will be useful to you too.

The "Pangolin" in the name is a loose acronym for _**PAN**doc-based **G**ithub d**O**cuments in htm**L** us**I**ng markdow**N**_.  (By the way, [pangolins are the most trafficked mammals](https://www.economist.com/news/science-and-technology/21736108-help-though-may-be-coming-some-natures-weirdest-mammals-are-some-most) in the world because stupid humans mistakenly think that eating them provides health benefits.  Please [learn more about them](http://video.nationalgeographic.com/video/short-film-showcase/the-tragic-tale-of-a-pangolin-the-worlds-most-trafficked-animal) and the [cruel way people treat them](https://en.wikipedia.org/wiki/Pangolin_trade#Black_market), and [help stop their hunting](http://savepangolins.org/help/) before they are driven to extinction.)

✺ Installing Pangolin Notebook
------------------------------

### ⓵&nbsp;&nbsp; _Install software that Pangolin Notebook depends upon_

Before you can use Pangolin Notebook, you will need the following software installed on your computer (using whatever method you prefer on your computer):

* [Pandoc](https://pandoc.org) version 2.1 or later, with LaTeX and BibTeX support
* [GNU Make](https://www.gnu.org/software/make/)
* [fswatch](https://github.com/emcrisostomo/fswatch) (if you want to use Pangolin Notebooks' auto-rebuild approach)
* Common Unix/Linux utility programs such as `bash`, `ls`, `cp`, `sed`, etc. 

### ⓶&nbsp;&nbsp; _Install Pangolin Notebook_

The basic approach is to create a fresh directory for your notebook, add the Pangolin Notebook source files into a _subdirectory_ of that directory, and do some final configuration steps.  In more detail, the following steps should get you started:

1. Create a directory for your notebook and `cd` into it
2. `git init`
3. `git submodule add https://github.com/mhucka/pangolin-notebook.git`
4. `./pangolin-notebook/setup`

The setup step will create a new subdirectory called `docs` in which your notebook files are meant to be located.  It will also create a few files as starting templates to help you understand the format.

### ⓷&nbsp;&nbsp; _Configure Pangolin Notebook_

The step of running `setup` above will copy a file named `pangolin.yml` into your notebook directory.  This file needs to be edited to set certain variables. You can edit it using any text editor.  The file contains comments that explain the variables; only four variables _must_ be set because Pangolin Notebook cannot figure them out itself:

* `content-pages` &ndash; this contains a list of the files that constitute the top-level pages of your notebook.  **You need to update this variable every time you add a new notebook page**.
* `sitename` &ndash; a short name for your site
* `copyright` &ndash; a license for others to quote or use your content
* `notebook-url` &ndash; the online URL (e.g., `https://yourlogin.github.io/yournotebook` if you're using GitHub Pages)

There are some additional variables in `pangolin.yml` that you can set, such as `feedback-url` if you want to point people to (e.g.,) an issue tracker, and `bib-style` if you want to use a different reference style file.


► Using Pangolin Notebook
------------------------

Writing documents is a matter of creating and editing in [Pandoc-flavored Markdown](https://pandoc.org/MANUAL.html) format (optionally writing references in [BibTeX](http://www.bibtex.org/Format) format and creating figures in any web-viewable format you choose), then running `make` in your notebook directory to (re)generate the HTML files for your notebook contents.  The latter process can be automated using the `make autorefresh` command, which uses a combination of JavaScript inserted into every HTML page and `fswatch` to let you keep a web browser open on your notebook and have it be refreshed automatically each time you save changes to your files.

### Writing documents and previewing the results

When you create new files in your `docs` directory, you need to update the value of the variable `content-pages` in the file `pangolin.yml`.  The order in which the files are listed is the order in which they will appear  in the table of contents on the front page of your notebook.

To generated formatted output, you can manually run the following command in your notebook directory:

```
make
```

The `index.html` file will be placed at the top level of your notebook directory, and the formatted output for all other pages will be placed in the `docs` directory.  Normally, the process should only recreate those files that need to be recreated based on whether the corresponding source `.md` files have changed.  If you need to force the regeneration of everything, use `make force`.

Pangolin Notebook includes an auto-refresh facility that puts JavaScript code into every HTML page to detect that the underlying file has been changed. (It _only_ does this for files on your local computer, not for files located anywhere else&mdash;it will not do this on GitHub Pages, for example.)  This is meant to work in conjunction with a simple auto-re-`make` scheme to let you view the formatted HTML in a browser as you edit.  To take advantage of this, run the following command in your notebook directory:

```
make autorefresh
```

Then open a notebook page in your browser, and try editing the corresponding Markdown file.  After a second or two, the page in your web browser should refresh to show the changed version.

### Committing the results

_... more forthcoming ..._


### Publishing updates to GitHub pages

_... more forthcoming ..._


★ Do you like it?
------------------

If you like this software, don't forget to give this repo a star on GitHub to show your support!

⁇ Getting help and support
--------------------------

If you find an issue, please submit it in [the GitHub issue tracker](https://github.com/mhucka/pangolin-notebook/issues) for this repository.


♬ Contributing &mdash; info for developers
------------------------------------------

I would be happy to receive your help and participation if you are interested.  Everyone is asked to read and respect the [code of conduct](CONDUCT.md) when participating in this project.


🏛 Copyright and license
---------------------

Copyright (c) 2017 by Michael Hucka and the California Institute of
Technology.

The original files in this project are licensed under the MIT License.  This project makes use of files from other projects such as [Bootstrap](http://bootstrapdocs.com/v3.0.1/docs/).  Please see the file [LICENSE](LICENSE) for complete copyright and license details.


☺ Acknowledgments
-----------------------

The code for detecting changes in a page was originally created by S. Fuchs and described in a [blog entry](https://kiwidev.wordpress.com/2011/07/14/auto-reload-page-if-html-changed/).  The JavaScript CRC check function used here was [posted to Stack Overflow](https://stackoverflow.com/a/18639999/743730) by user "Alex".  The image of the illustration of a Pangolin used on this page [came from Wikimedia](https://commons.wikimedia.org/wiki/File:PholidotusAfricanusWolf.jpg) and was originally created by Joseph Wolf and published in the Proceedings of the Zoological Society of London, 1865.
