## ============================================================================
## Description : Main makefile for generating a formatted Pangolin Notebook
## Author(s)   : Michael Hucka <mhucka@caltech.edu>
## Organization: California Institute of Technology
## Date created: 2017-10-13
## Source      : https://github.com/mhucka/pangolin-notebook
## ============================================================================
##
## NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE
##
## This makefile assumes that it is being included by another makefile that
## sets necessary variable values.  This makefile is incomplete by itself.
##
## NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE
##
## ----------------------------------------------------------------------------


# Advanced customization variables.
# .............................................................................
# These can be changed, but doing so can have unexpected consequences, so
# they are slightly hidden in this second-level makefile.

# The style used for formatting bibliographies.  The file will be found in
# the "styles" subdirectory of wherever the Pangolin Notebook files are.

bib-style = modified-acm-siggraph.csl

# The template for individual notebook pages.  The file will be found in
# the "templates" subdirectory of wherever the Pangolin Notebook files are.

page-template = pangolin-page.html


# Main code -- no more customization variables after this point
# .............................................................................

pangolin-dir	:= $(notebook-dir)/$(pangolin-notebook)
input-dir       := $(notebook-dir)/$(contents-dir)

# Inputs

contents-file   := $(notebook-dir)/$(contents-list)
input-filenames := $(shell grep -v "^\s*\#|$(front-page)|$(about-page)" $(contents-file))
input-files     := $(patsubst %,$(input-dir)/%,$(input-filenames))
bib-files	:= $(wildcard $(input-dir)/*.bibtex)
front-page-file := $(input-dir)/$(front-page)
about-page-file := $(input-dir)/$(about-page)

# Outputs

index-file	:= $(output-dir)/index.html
about-file      := $(output-dir)/$(about-page:.md=.html)
output-files	:= $(patsubst %,$(output-dir)/%,$(input-filenames:.md=.html))

# Templates

doc-template	:= $(pangolin-dir)/templates/$(page-template)
toc-template	:= $(pangolin-dir)/templates/pangolin-toc.html
nav-template	:= $(pangolin-dir)/templates/pangolin-navbar.html
bib-style-csl	:= $(pangolin-dir)/styles/citation-styles/$(bib-style)

# Temp files

navbar          := _nav.html
toc             := _toc.html

# Style files

styles-dir      := $(pangolin-notebook)/styles

css-files-src   := $(styles-dir)/pangolin/css/pangolin-notebook.css \
		   $(styles-dir)/bootstrap/css/bootstrap-theme.min.css \
		   $(styles-dir)/bootstrap/css/bootstrap.min.css

js-files-src    := $(styles-dir)/pangolin/js/html-crc-reload.js \
		   $(styles-dir)/bootstrap/js/bootstrap.min.js \
		   $(styles-dir)/bootstrap/js/html5shiv.js \
		   $(styles-dir)/bootstrap/js/jquery.min.js \
		   $(styles-dir)/bootstrap/js/less-1.3.3.min.js

font-files-src  := $(styles-dir)/bootstrap/fonts/glyphicons-halflings-regular.eot \
		   $(styles-dir)/bootstrap/fonts/glyphicons-halflings-regular.svg \
	 	   $(styles-dir)/bootstrap/fonts/glyphicons-halflings-regular.ttf \
		   $(styles-dir)/bootstrap/fonts/glyphicons-halflings-regular.woff

css-files       := $(addprefix $(output-dir)/css/,$(notdir $(css-files-src)))
js-files        := $(addprefix $(output-dir)/js/,$(notdir $(js-files-src)))
font-files      := $(addprefix $(output-dir)/fonts/,$(notdir $(font-files-src)))

style-files     := $(css-files) $(js-files) $(font-files)

# Arguments to pandoc

doc-args = \
	-f markdown \
	-t html \
	--standalone \
	--smart \
	--number-sections \
	--email-obfuscation=none \
	--mathjax \
        --metadata link-citations=true \
	--metadata date="`date "+%B %e, %Y"`" \
	--include-before-body=$(navbar) \
	--template=$(doc-template) \
	--data-dir $(notebook-dir) \
	--csl=$(bib-style-csl) \
	$(patsubst %,--bibliography %,$(bib-files))

toc-args = \
	-t html \
	--standalone \
	--smart \
	--number-sections \
	--toc \
	--toc-depth=1 \
	--metadata date="`date "+%B %e, %Y"`" \
	--template=$(toc-template)

index-args = \
	-t html \
	--standalone \
	--smart \
	--toc \
	--toc-depth=1 \
	--template=$(toc-template)

nav-args = \
	-t html \
	--standalone \
	--smart \
	--variable about_page="$(about-page:.md=.html)" \
	--variable notebook_url="$(notebook-url)" \
	--variable source_url="$(source-url)" \
	--template=$(nav-template)

# Action rules.

default: | create-dirs $(navbar) $(style-files)
default: $(index-file) $(output-files) $(contents-file) $(about-file)

create-dirs:
	mkdir -p $(output-dir)
	mkdir -p $(output-dir)/css
	mkdir -p $(output-dir)/js
	mkdir -p $(output-dir)/fonts

$(navbar): $(nav-template) $(contents-file)
	pandoc $(nav-args) $(nav-template) -o $(navbar)

$(index-file): $(front-page-file) $(input-files) $(contents-file)
$(index-file): $(doc-template) $(toc-template)
	echo '<ul class="toc">' > $(toc)
	for file in $(input-files); do \
	    html="$${file/$(contents-dir)/$(output-dir)}"; \
	    html="$${html/.md/.html}"; \
	    pandoc $(doc-args) $$file -o $$html; \
	    title=`grep 'title:' $$file | cut -f2 -d':'`; \
	    echo "<li><a href=\"$$html\"><span class=\"toc-entry\">" $$title "</span></a></li>" >> $(toc); \
	done;
	echo '</ul>' >> $(toc)
	pandoc $(doc-args) $(front-page-file) | contents=`cat $(toc)` envsubst '$$contents' > $(index-file)
	-rm -f $(toc) $(navbar)

$(output-dir)/%.html: $(contents-dir)/%.md
	pandoc $(doc-args) $< -o $@

$(about-file): $(about-page-file)
	pandoc $(doc-args) $< -o $@

$(output-dir)/css/%.css: $(styles-dir)/bootstrap/css/%.css
	cp -rp $(styles-dir)/bootstrap/css/$(notdir $<) $(output-dir)/css/$(notdir $<)

$(output-dir)/css/%.css: $(styles-dir)/pangolin/css/%.css
	cp -rp $(styles-dir)/pangolin/css/$(notdir $<) $(output-dir)/css/$(notdir $<)

$(output-dir)/js/%.js: $(styles-dir)/bootstrap/js/%.js
	cp -rp $(styles-dir)/bootstrap/js/$(notdir $<) $(output-dir)/js/$(notdir $<)

$(output-dir)/js/%.js: $(styles-dir)/pangolin/js/%.js
	cp -rp $(styles-dir)/pangolin/js/$(notdir $<) $(output-dir)/js/$(notdir $<)

$(output-dir)/fonts/%: $(styles-dir)/bootstrap/fonts/%
	cp -rp $(styles-dir)/bootstrap/fonts/$(notdir $<) $(output-dir)/fonts/$(notdir $<)

clean:
	-rm -f $(output-files) $(index-file) $(navbar) $(toc) $(about-file) \
		$(style-files)
	-rmdir $(output-dir)/css $(output-dir)/js $(output-dir)/fonts
	-rmdir $(output-dir)

watch-files := $(input-files) $(front-page-file) $(about-page-file) \
		$(doc-template) $(toc-template) $(nav-template) \
		$(bib-style-csl) $(css-files-src) $(js-files-src) $(font-files-src)

autorefresh:;
	((ls $(watch-files) | entr make) &)

.PHONY: create-dirs


# End.
# .............................................................................
