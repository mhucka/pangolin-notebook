## ============================================================================
## Description : Makefile for generating a formatted Pangolin Notebook
## Author(s)   : Michael Hucka <mhucka@caltech.edu>
## Organization: California Institute of Technology
## Date created: 2014-01-24
## Source      : https://github.com/mhucka/pangolin-notebook
## ============================================================================
##
## The basic idea is to create a git directory for your notebook, then add the
## Pangolin Notebook repository as a submodule of that.
##
##  1. create a directory somewhere
##  2. git init
##  3. git submodule add git@github.com:mhucka/pangolin-notebook.git
##  4. cp pangolin-notebook/Makefile .
##  5. edit the Makefile to adjust configuration variables
##
## Normal usage:
##
##   make
##       Regenerates the formatted HTML output in the directory $(output)
##       using the contents in $(input).  If none of the input files have
##       been changed, it does nothing.
##
##   make -B
##       Force regenerating all output files.  Useful for testing, or when
##       you update the pandoc binary on your computer.
##
##   make clean
##       Deletes all HTML files from the directory $(output).
##
## ----------------------------------------------------------------------------

# The next variable is the directory where you will put contents pages in
# Markdown format.

input	   = contents

# The next variable determines where the formatted output is placed.  If you
# use "docs" as the output directory, you will be able to use a built-in
# feature of GitHub Pages where you can make the GitHub pages use a /docs
# folder instead of the the root of the repository:
# https://github.com/blog/2228-simpler-github-pages-publishing

output	   = docs

# The next file should contain BibTeX entries for references.

bib-file   = $(input)/references.bib

# The next file name will be relative to pangolin-notebook/src/templates

bib-style  = apa-5th-edition.csl

# The next variable is used to locate your copy of the Pangolin Notebook
# distribution.  If you used the approach of "git submodule add ..." described
# in the comments above, then this will have the following value:
#   pangolin-notebook = pangolin-notebook

pangolin-notebook = .

# End of configuration section -- do not change the text below
# -----------------------------------------------------------------------------

include $(pangolin-notebook)/Makefile-main.mk
