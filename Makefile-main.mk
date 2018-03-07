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
## THIS FILE IS NOT MEANT TO BE EDITED. There is no user-configurable content.
## This makefile assumes that it is being included by another makefile that
## sets necessary variable values.  This makefile is incomplete by itself.
##
## NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE -- NOTE
##
## ----------------------------------------------------------------------------

# First read the config file and set Make variables.  This uses a hack: the
# line to set variable "trigger-parsing" causes Make to execute a command that
# includes calling 'eval', which sets values in the running Make process.

config          := $(notebook-dir)/pangolin.yml
trigger-parsing := $(foreach v,$(shell . $(pangolin)/yaml.sh; parse_yaml $(config)),$(eval $v))

# Inputs

content-dir     := docs
input-filenames := $(filter-out $(front-page),$(content-pages))
input-filenames := $(filter-out $(about-page),$(input-filenames))
input-files     := $(patsubst %,$(content-dir)/%,$(input-filenames))
bib-files	:= $(wildcard $(content-dir)/*.bibtex)
front-page-file := $(content-dir)/$(front-page)
about-page-file := $(content-dir)/$(about-page)

# Outputs

index-file	:= $(content-dir)/index.html

output-dir      := $(content-dir)
output-files	:= $(patsubst %,$(output-dir)/%,$(input-filenames:.md=.html))
about-file      := $(output-dir)/$(about-page:.md=.html)

# Templates

doc-template	:= $(pangolin)/templates/pangolin-page.html
toc-template	:= $(pangolin)/templates/pangolin-toc.html
bib-style-csl	:= $(pangolin)/styles/citation-styles/$(bib-style)

# Files that create the look & feel of Pangolin Notebook.

styles-dir      := $(pangolin)/styles

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

# Temp files

toc             := $(content-dir)/_toc.html

# Arguments to pandoc

doc-args = \
	-f markdown+smart \
	-t html \
	--standalone \
	--number-sections \
	--email-obfuscation=none \
	--mathjax \
        --metadata link-citations=true \
	--metadata date="`date "+%B %e, %Y"`" \
	--variable content-dir="$(content-dir)" \
	--variable about-page="$(about-page:.md=.html)" \
	--variable notebook-url="$(notebook-url)" \
	--variable source-url="$(source-url)" \
	--variable feedback-url="$(feedback-url)" \
	--template=$(doc-template) \
	--data-dir $(notebook-dir) \
	--csl=$(bib-style-csl) \
	$(patsubst %,--bibliography %,$(bib-files))

# Action rules.

default: | create-dirs $(css-files) $(js-files) $(font-files)
default: $(index-file) $(output-files) $(about-file) $(config)

$(index-file): $(front-page-file) $(input-files) $(config)
$(index-file): $(doc-template) $(toc-template)
	echo '<ul class="toc">' > $(toc)
	for file in $(input-filenames); do \
	    html="$${file/.md/.html}"; \
	    pandoc $(doc-args) $(content-dir)/$$file -o $(content-dir)/$$html; \
	    title=`grep 'title:' $(content-dir)/$$file | cut -f2 -d':'`; \
	    echo "<li><a href=\"$$html\"><span class=\"toc-entry\">" $$title "</span></a></li>" >> $(toc); \
	done;
	echo '</ul>' >> $(toc)
	pandoc $(doc-args) $(front-page-file) | contents=`cat $(toc)` envsubst '$$contents' > $(index-file)

$(output-dir)/%.html: $(content-dir)/%.md $(config)
	pandoc $(doc-args) $< -o $@

$(about-file): $(about-page-file) $(config)
	pandoc $(doc-args) $< -o $@

create-dirs: $(output-dir) $(output-dir)/css $(output-dir)/js $(output-dir)/fonts

$(output-dir):
	mkdir -p $(output-dir)

$(output-dir)/css:
	mkdir -p $(output-dir)/css

$(output-dir)/js:
	mkdir -p $(output-dir)/js

$(output-dir)/fonts:
	mkdir -p $(output-dir)/fonts

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

clean:;
	-rm -f $(output-files) $(index-file) $(toc) $(about-file)

watch-files := $(input-files) $(front-page-file) $(about-page-file) $(config) \
		$(doc-template) $(toc-template) $(bib-style-csl) \
		$(css-files-src) $(js-files-src) $(font-files-src)

push:;
	(git add . && git commit && git push)

# Autorefresh excludes Emacs backup files, checkpoint files, and the HTML
# files (because make would otherwise run twice every time it generated
# a new HTML file).

autorefresh:;
	((fswatch -0 -o -I -e '*~' -e '\.#.*' -e '.*\.html' $(content-dir) $(config) | xargs -0 -I {} make) &)

help:
	@echo 'This is the Makefile for a Pangolin Notebook website.'
	@echo 'Available commands:'
	@echo ''
	@echo '  make'
	@echo '    Regenerates the formatted HTML output if necessary. If none'
	@echo '    of the input files have been changed, it does nothing.'
	@echo ''
	@echo '  make -B'
	@echo '    Forces regenerating all output files even if the input'
	@echo '    files have not been changed. Useful for testing or when'
	@echo '    you update the pandoc binary on your computer.'
	@echo ''
	@echo '  make autorefresh'
	@echo '    Starts a process to watch the input files and regenerate'
	@echo '    the formatted output automatically when the inputs have'
	@echo '    changed. To take advantage of this, open the index HTML'
	@echo '    file (or other HTML file from the notebook) in a web'
	@echo '    browser, and thereafter when you edit the source files,'
	@echo '    Pangolin Notebook will rerun pandoc and automatically'
	@echo '    refresh the browser view.'
	@echo ''
	@echo '  make push'
	@echo '    Commits changes to git and pushes an update to the remote.'
	@echo ''
	@echo '  make clean'
	@echo '    Deletes all HTML files from the output directory.'
	@echo ''
	@echo '  make help'
	@echo '    Print this summary of available commands.'
	@echo ''
	@echo 'Do not forget to update the file "pangolin.yml" whenever you'
	@echo 'add new Markdown files. Pangolin Notebook can figure out when'
	@echo 'files have changed, but it cannot figure out on its own the'
	@echo 'files that are meant to be added to the table of contents.'
	@echo ''
	@echo 'For more information about Pangolin Notebook, please visit the'
	@echo 'following website: http://github.com/mhucka/pangolin-notebook'

# Miscellaneous convenience commands.

html: default

.PHONY: create-dirs html help clean autorefresh push
