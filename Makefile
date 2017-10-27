## ============================================================================
## Description : Makefile for generating a formatted Pangolin Notebook
## Author(s)   : Michael Hucka <mhucka@caltech.edu>
## Organization: California Institute of Technology
## Date created: 2017-10-13
## Source      : https://github.com/mhucka/pangolin-notebook
## ============================================================================
##
## This Makefile is meant to be copied to your notebook directory.  It
## references other files in Pangolin Notebook, and expects Pangolin Notebook
## to be place in a subdirectory of your notebook directory.  (The best way
## to achieve that is to use a git clone or git submodule.  See the README.md
## file for more detailed instructions.)
##
## After you have copied this Makefile to your notebook directory, edit the
## configuration variables below.  Once that is done, you can use "make" to
## generate the output for your notebook.
##
## The following are possible make commands that the Pangolin Notebook
## makefiles are designed to support:
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

# A file that lists, on separate lines, each file to be made part of the
# notebook.  The order in which the files are listed in this file is the
# order in which the pages will be put in the table of contents.  (Also see
# the variable "front-page" below.)

contents-list = TABLE-OF-CONTENTS

# The directory containing the content files.  This directory should also
# contain the "front-page" and "about" page files (see below).

contents-dir = contents

# The file that is the front page of the notebook.  The text inside this file
# should contain one instance of the literal string "$contents" to indicate
# where the table of contents should be placed on the page.

front-page = front-page.md

# The file that will be used to create the "About" page.

about-page = about.md

# The URL to the live, online notebook.  If you are using GitHub Pages, this
# will be something like "https://yourlogin.github.io/yournotebook".

notebook-url = https://mhucka.github.io/dcan

# (Optional) The URL to the source repo for your notebook, if you want to show
# this in the navigation bar.  This can be, for example, the GitHub repo URL.
# Leave empty if the resource repo is not public.

source-url = https://github.com/mhucka/dcan

# The next variable determines where the formatted output is placed.  If you
# use "docs" as the output directory, you will be able to use a convenient
# built-in feature of GitHub Pages where you can make the GitHub pages use 
# a /docs folder instead of the the root of the repository -- see here:
# https://github.com/blog/2228-simpler-github-pages-publishing

output-dir = docs

# The next variable is used to find your copy of the Pangolin Notebook
# distribution.  If you used git clone or git add submodule to put the copy
# in your notebook directory,then this will have the following value:
#    pangolin-notebook = pangolin-notebook

pangolin-notebook = pangolin-notebook


# End of configuration section -- do not change the text below.
# -----------------------------------------------------------------------------

notebook-dir := $(shell pwd)
include $(pangolin-notebook)/Makefile-main.mk
