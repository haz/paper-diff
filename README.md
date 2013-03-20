paper-diff
==========

Uses latexdiff tool to modify an entire latex project for showing changes between revisions.

Usage is simple:
./paper-diff.sh directory/path <old revision>

It is far buggier when the old revision is far back (i.e., way too many changes).
Change the MAINFILE variable if your have named you central document differently
(currently main.tex is used). It will not work if the tex files are nested in
directories.
