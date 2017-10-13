## ============================================================================
## Description : Makefile for generating a formatted Pangolin Notebook
## Author(s)   : Michael Hucka <mhucka@caltech.edu>
## Organization: California Institute of Technology
## Date created: 2014-01-24
## Source      : https://github.com/mhucka/pangolin-notebook
## ============================================================================
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

# Content and output directories.

input	   = contents
output	   = /tmp/formatted

# The index file serves as a kind of marker file; it is always regenerated if
# the source files are changed, and regenerating it causes everything else to
# be regenerated.  This is not the most efficient approach, but it makes this
# makefile simple, and besides, the notebook is short enough that the time to
# do it all is short.  That is why the default target here is "notebook".

notebook: $(output)/index.html

# Running "make clean" will remove the formatted HTML files.

clean:
	rm -f $(wildcard $(output)/*.html)

# The order of the files in the contents directory must be given in the file
# ORDER.  The list in the file ORDER must *exclude* the special files
# front-matter.md and about.md, even though we put those files in the
# contents/ directory too.

body-files = $(shell grep -v '^\s*\#' $(input)/ORDER)

# The bibliography file is set by the next variable.

bib-file = $(input)/references.bib

# The remainder below should not need to change under most circumstances.

template-dir = src/notebook-templates

body-tp	     = $(template-dir)/body-template.html
single-pg-tp = $(template-dir)/single-page-template.html

header-tp    = $(template-dir)/header-template.html
nav-tp       = $(template-dir)/nav-template.html
toc-tp       = $(template-dir)/toc-template.html
index-top-tp = $(template-dir)/index-top-template.html
index-bot-tp = $(template-dir)/index-bottom-template.html
bib-csl-file = $(template-dir)/apa-5th-edition.csl

# There are dependencies between the Pandoc arguments listed here and the
# processing done below.  For instance, --toc and -number-sections must
# remain or the other stuff below will break.

args = \
	-f markdown \
	--csl=$(bib-csl-file) \
	--data-dir $(output) \
	--include-in-header=$(header-tp) \
	--email-obfuscation=none \
	--number-sections \
	--mathjax \
	--smart \
	--toc

# Pandoc doesn't offer a way to generate a table of contents for multipage
# HTML output.  The approach taken here uses two passes.  First, pandoc is
# run over each input file using a special template solely for generating the
# table of contents for one file.  The output is massaged using sed, and
# appended to a temporary file called toc.html.  Then, the content of this
# file is inserted into the navigation bar and the file index.html using sed
# for the former and simple file append commands for the latter.
#
# This convoluted mess should not be necessary for other output formats
# such as LaTeX and ePUB.  It's just the HTML case that needs this.

pan-toc	 = pandoc $(args) --template=$(toc-tp)
pan-body = pandoc $(args) -B nav.html --bibliography=$(bib-file)
pan-misc = pandoc $(args) -B nav.html

timestamp   = $(shell date '+%G-%m-%d %H:%M %Z')
file-count  = $(words $(body-files))

sed-match-head   = .*\#\([^\"]*\)\"><span class=\"toc-section-number\">\([0-9]\)</span>\(.*\)</a>.*
sed-replace-head = <li class=\"headline\"><a href=\"$$out\#\1\"><span class=\"section-number\">\2</span>\3</a></li>

sed-match-rest   = .*\#\([^\"]*\)\"><span class=\"toc-section-number\">\([0-9]\..*\)</span>\(.*\)</a>.*
sed-replace-rest = <li><a href=\"$$out\#\1\"><span class=\"section-number\">\2</span>\3</a></li>

$(output)/index.html: $(wildcard $(input)/*.md) $(input)/ORDER
$(output)/index.html: $(header-tp) $(nav-tp) $(body-tp) $(toc-tp)
$(output)/index.html: Makefile $(index-top-tp) $(index-bot-tp)
	mkdir -p $(output)
	make style-files
	rm -f toc.html
	num=1; \
	for in in $(body-files); do \
	  out="$${in%.md}.html"; \
	  offset=`expr $$num - 1`; \
	  $(pan-toc) --number-offset=$$offset -o $(output)/$$out $(input)/$$in; \
	  sed -n -e "s|$(sed-match-head)|$(sed-replace-head)|p" < $(output)/$$out >> toc.html; \
	  sed -n -e "s|$(sed-match-rest)|$(sed-replace-rest)|p" < $(output)/$$out >> toc.html; \
	  if test $$num -ne $(file-count); then \
	    echo "<li class=\"divider\">" >> toc.html; \
	  fi; \
	  num=`expr $$num + 1`; \
	done;
	sed -e '/<!-- @@HTML-TOC@@ -->/r toc.html' < $(nav-tp) > nav.html
	offset=0; \
	for in in $(body-files); do \
	  out="$${in%.md}.html"; \
	  $(pan-body) --template=$(body-tp) --number-offset=$$offset -o $(output)/$$out $(input)/$$in; \
	  offset=`expr $$offset + 1`; \
	done;
	$(pan-misc) --template=$(single-pg-tp) -o $(output)/about.html $(input)/about.md
	sed -e 's/<!-- @@TIMESTAMP@@ -->/$(timestamp)/' < $(input)/front-matter.md > index.md
	$(pan-misc) --template=$(index-top-tp) -o $(output)/index.html index.md
	cat toc.html >> $(output)/index.html
	$(pan-misc) --template=$(index-bot-tp) -o index-bottom.html index.md
	cat index-bottom.html >> $(output)/index.html
	rm -f toc.html nav.html index.md index-bottom.html

# -----------------------------------------------------------------------------
# The following rules populate the formatted/css, etc., directories from the
# source files, and also describe some additional common dependencies.  It is
# unlikely that anything below this point needs to be changed in common
# updates of this Makefile.
# -----------------------------------------------------------------------------

notebook-css-files = \
	notebook.css

notebook-js-files = \
	html-crc-reload.js

bootstrap-css-files = \
	bootstrap-theme.css \
	bootstrap-theme.min.css \
	bootstrap.css \
	bootstrap.min.css

bootstrap-img-files = \
	glyphicons-halflings-white.png \
	glyphicons-halflings.png

bootstrap-js-files = \
	bootstrap.min.js \
	html5shiv.js \
	jquery.min.js \
	less-1.3.3.min.js

bootstrap-font-files = \
	glyphicons-halflings-regular.eot \
	glyphicons-halflings-regular.svg \
	glyphicons-halflings-regular.ttf \
	glyphicons-halflings-regular.woff

$(output)/css/%.css: src/bootstrap/css/%.css
	$(shell [ -d $(output)/css ] || mkdir -p $(output)/css)
	cp -rp src/bootstrap/css/$(notdir $<) $(output)/css/$(notdir $<)

$(output)/css/%.css: src/notebook-css/%.css
	$(shell [ -d $(output)/css ] || mkdir -p $(output)/css)
	cp -rp src/notebook-css/$(notdir $<) $(output)/css/$(notdir $<)

$(output)/img/%.png: src/bootstrap/img/%.png
	$(shell [ -d $(output)/img ] || mkdir -p $(output)/img)
	cp -rp src/bootstrap/img/$(notdir $<) $(output)/img/$(notdir $<)

$(output)/js/%.js: src/bootstrap/js/%.js
	$(shell [ -d $(output)/js ] || mkdir -p $(output)/js)
	cp -rp src/bootstrap/js/$(notdir $<) $(output)/js/$(notdir $<)

$(output)/js/%.js: src/notebook-js/%.js
	$(shell [ -d $(output)/js ] || mkdir -p $(output)/js)
	cp -rp src/notebook-js/$(notdir $<) $(output)/js/$(notdir $<)

$(output)/fonts/%.eot: src/bootstrap/fonts/%.eot
	$(shell [ -d $(output)/fonts ] || mkdir -p $(output)/fonts)
	cp -rp src/bootstrap/fonts/$(notdir $<) $(output)/fonts/$(notdir $<)

$(output)/fonts/%.svg: src/bootstrap/fonts/%.svg
	$(shell [ -d $(output)/fonts ] || mkdir -p $(output)/fonts)
	cp -rp src/bootstrap/fonts/$(notdir $<) $(output)/fonts/$(notdir $<)

$(output)/fonts/%.ttf: src/bootstrap/fonts/%.ttf
	$(shell [ -d $(output)/fonts ] || mkdir -p $(output)/fonts)
	cp -rp src/bootstrap/fonts/$(notdir $<) $(output)/fonts/$(notdir $<)

$(output)/fonts/%.woff: src/bootstrap/fonts/%.woff
	$(shell [ -d $(output)/fonts ] || mkdir -p $(output)/fonts)
	cp -rp src/bootstrap/fonts/$(notdir $<) $(output)/fonts/$(notdir $<)

css-files       = $(addprefix $(output)/css/,$(bootstrap-css-files)) \
                  $(addprefix $(output)/css/,$(notebook-css-files))

img-files       = $(addprefix $(output)/img/,$(bootstrap-img-files))

js-files        = $(addprefix $(output)/js/,$(bootstrap-js-files)) \
                  $(addprefix $(output)/js/,$(notebook-js-files))

font-files      = $(addprefix $(output)/fonts/,$(bootstrap-font-files))

all-style-files = $(css-files) $(img-files) $(js-files) $(font-files)

style-files: $(all-style-files)

# -----------------------------------------------------------------------------
# Miscellaneous items.
# -----------------------------------------------------------------------------

.SUFFIXES:
.SUFFIXES: .md .css .js .svg .ttf .eot .woff .png .jpg .html
