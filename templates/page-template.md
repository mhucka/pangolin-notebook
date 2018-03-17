---
title: This is a page in the notebook
date: {DATE}
author:
- Your Name
---

This is a sample page in the notebook.  Use normal Markdown to write the text. You can insert figures using the following HTML syntax; figure contents can be in any common image format using the `<img>` tag or SVG drawings using the `<svg>` tag:

<figure>
  <svg width="100" height="100"><circle cx="50" cy="50" r="40" stroke="black" stroke-width="1" fill="#999999" /></svg> 
  <figcaption>You can write the caption for the figure here.  The resulting text will appear below the figure in the formatted HTML.  Note that GitHub will not display this in the GitHub source repository views, but GitHub Pages will render the result correctly.</figcaption>
</figure>

Citations go inside square brackets and are separated by semicolons. Each citation must have a key composed of the character `@` followed by the citation identifier from your BibTeX reference file, and may optionally have a prefix, a locator, and a suffix. The following are some examples:

```
Blah blah blah [see @someauthor2015, p. 50; also @someone2011, chap. 1].

Blah blah blah [@john2010; @smith1899].
```
