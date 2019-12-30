#!/bin/mksh

set -euo pipefail

echo cleaning old build...
rm build/*

for content_file in content/*.md; do
	
	name=$(basename $content_file .md)
	build_file="build/$name.html"

	echo building $name...

	links_file="links/$name.links.md"
	[ -f $links_file ] || links_file='links/back.links.md'

	cat html/html.head.txt > $build_file
	cmark $links_file >> $build_file
	echo '</div>' >> $build_file
	cmark $content_file >> $build_file
	echo '</body>' >> $build_file

done

cp -av content/*.txt build/
cp -av html/linuxconsole.css build/
cp -av html/robots.txt build/
cp -av sitemap/sitemap.xml build/

echo build done.
