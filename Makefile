## ============================================================================
## Description : User Makefile for generating a formatted Pangolin Notebook
## Author(s)   : Michael Hucka <mhucka@caltech.edu>
## Organization: California Institute of Technology
## Date created: 2017-10-13
## Source      : https://github.com/mhucka/pangolin-notebook
## ============================================================================
##
## This Makefile is meant to be copied to your notebook directory.  DO NOT
## EDIT THIS FILE.  It references other files in Pangolin Notebook, and
## expects Pangolin Notebook to be place in a subdirectory of your notebook
## directory.  (The best way to achieve that is to use a git clone or git
## submodule.  See the Pangolin Notebook README.md file for instructions.)
##
## The configuration of a Pangolin Notebook is set by the file "pangolin.yaml"
## expected to be in the root of the notebook directory (the same location as
## this Makefile will be).
##
## The following are possible make commands that the Pangolin Notebook
## makefiles are designed to support:
##
##   make
##       Regenerates the formatted HTML output if necessary. If none of the
##       input files have been changed, it does nothing.
##
##   make -B
##       Forces regenerating all output files.  Useful for testing, or when
##       you update the pandoc binary on your computer.
##
##   make clean
##       Deletes all HTML files from the output directory.
##
##   make autorefresh
##       Sets up a process to watch the input files and regenerate the
##       formatted output automatically when the files are changed.  To take
##       advantage of this, open the index HTML file (or other HTML file from
##       the notebook) in a web browser, and thereafter when you edit the
##       source files, Pangolin Notebook will rerun pandoc and automatically
##       refresh the browser view.
##
## ----------------------------------------------------------------------------

# Do not change the text below.

notebook-dir := $(CURDIR)
pangolin := $(CURDIR)/pangolin-notebook
include $(pangolin)/Makefile-main.mk
