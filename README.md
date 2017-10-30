Pangolin Notebook<img width="280px" title="Illustration of Pangolin by Joseph Wolf, 1865, Proceedings of the Zoological Society of London" align="right" src=".graphics/1600px-PholidotusAfricanusWolf-sm.jpg">
================

Pangolin Notebook is a template for creating an online notebook written using [Pandoc](https://pandoc.org)-flavored [Markdown](https://pandoc.org/MANUAL.html) with support for citations, mathematics, and simple hosting using [GitHub Pages](https://pages.github.com).  It includes an auto-refresh facility so that you can view the formatted results as you write.

*Author*:      [Michael Hucka](http://github.com/mhucka)<br>
*Repository*:   [https://github.com/mhucka/pangolin-notebook](https://github.com/mhucka/pangolin-notebook)<br>
*License*:      Unless otherwise noted, this content is licensed under the [MIT License](https://opensource.org/licenses/MIT) license.

✺ Introduction
-------------

Pangolin Notebook grew out of my desire for a simple system to quickly write multipage scientific documents in plain text with references and mathematics, using GitHub and GitHub Pages to store the documents as well as allow easy collaboration with other people.  There are other systems for accomplishing roughly the same thing, but in every case that I tried, I encountered one or another roadblock or source of frustration.  Ultimately, I was led to create Pangolin Notebook.  I realize Pangolin Notebook is a variation on a common theme&mdash;yet another dot in a multidimensional space of possible features and approaches, if you will.  Please feel free to use it as a starting point for your own work; perhaps this particular formulation will be useful to you too.

The "Pangolin" in the name is a loose acronym for _**PAN**doc-based **G**ithub d**O**cuments in htm**L** us**I**ng markdow**N**_.  (By the way, [pangolins are one of the most illegally trafficked mammals](http://video.nationalgeographic.com/video/short-film-showcase/the-tragic-tale-of-a-pangolin-the-worlds-most-trafficked-animal) in the world because stupid humans think eating them provides health benefits.  Please read more about them and the [cruel way people treat them](https://en.wikipedia.org/wiki/Pangolin_trade#Black_market), and [help stop their hunting](http://savepangolins.org/help/) before they are driven to extinction.)

► Using Pangolin Notebook
------------------------

Writing documents in Pangolin Notebook is a matter of editing files in [Pandoc-flavored Markdown](https://pandoc.org/MANUAL.html) format (optionally writing references in [BibTeX](http://www.bibtex.org/Format) format and creating figures in any web-viewable format you choose), then running `make` in your notebook directory to update the formatted HTML files for your notebook contents.  The latter process can be automated using the `make autorefresh` command, which in combination with some JavaScript inserted into every HTML page, allows you to keep a web browser open on your notebook and have it be refreshed automatically each time you save changes to your files.

### Prerequisites

Before you can use Pangolin Notebook, you will need the following software installed on your computer:

* [Pandoc](https://pandoc.org) with LaTeX and BibTeX support
* [GNU Make](https://www.gnu.org/software/make/)
* [Bash](https://www.gnu.org/software/bash/)
* [gettext](https://www.gnu.org/software/gettext/)
* [entr](http://entrproject.org) (if you want to use Pangolin Notebooks' auto-refresh approach)
* Common Unix/Linux utility programs such as `ls`, `cp`, etc. 

### Installation and configuration

The basic approach to setting up Pangolin Notebook is to create a fresh directory for your new notebook, clone the Pangolin Notebook source files into a subdirectory of _that_, and do a couple of configuration steps to set up the notebook.  In more detail, the following steps should get you started:

1. Create a directory for your notebook
2. `cd` into that directory
3. Run the command `git clone git@github.com:mhucka/pangolin-notebook.git`
4. Run the command `cp pangolin-notebook/Makefile .` (note the trailing `.` is necessary!)
5. Edit the `Makefile` to change configuration variable values as needed
6. Create a subdirectory for your contents (perhaps call it `contents`)
7. Create a table of contents file (perhaps call it `TABLE-OF-CONTENTS`)

If you are going to use GitHub to share your notebook source files and GitHub Pages to share the formatted notebook, the steps are only slightly more involved:

1. Create a directory for your notebook
2. `cd` into that directory
3. Run the command `git init`
4. Run the command `git submodule add https://github.com/mhucka/pangolin-notebook.git`
5. Run the command `./pangolin-notebook/setup`
6. Edit the `Makefile` created by the previous step to change configuration variable values as needed
7. Create a subdirectory for your contents (perhaps call it `contents`)
8. Create a table of contents file (perhaps call it `TABLE-OF-CONTENTS`)

### Writing documents and previewing the results

From then on, you proceed by creating new files in your `contents` directory and writing their names inside the `TABLE-OF-CONTENTS` file.  The order in which the files are listed in the table of contents is the order in which they will appear on the front page of your notebook.

To generated formatted output, you can manually run the following command in your notebook directory:

```
make
```

The output will be placed in the output directory set in your `Makefile`; it is `docs` by default, which means that the formatted HTML output for your notebook will be found in the subdirectory `docs` after you run `make`.

Pangolin Notebook includes an auto-refresh facility that puts JavaScript code into every HTML page to detect the underlying file has been changed. (It _only_ does this for files on your local computer, not for files located anywhere else&mdash;it will not do this on GitHub Pages, for example.)  This is meant to work in conjunction with a simple auto-re-`make` scheme to let you view the formatted HTML in a browser as you edit.  To take advantage of this, run the following command in your notebook directory:

```
make autorefresh
```

Then open a notebook page in your browser, and try editing the corresponding Markdown file.  After a second or two, the page in your web browser should refresh to show the changed version.


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
