#!/bin/ksh

set -eu

echo '*** cleaning old build...'
[ -d _build ] && rm -r _build
mkdir -p _build

txt2html()
{
	sed 's|&|\&amp;|g' $1 	|
	sed 's|<|\&lt;|g'  	|
	sed 's|>|\&gt;|g' 	|
	sed "s|'|\&#39;|g"	|
	sed 's|"|\&quot;|g'
}

for txt_file in txt/*.txt; do
	
	name=$(basename $txt_file .txt)
	build_file="_build/${name}.html"

	echo "*** building ${name}..."

	links_file="assets/links.${name}.html"
	[ ! -f ${links_file} ] && links_file='assets/links.back.html'

	cat assets/html.header.html 	> $build_file
	cat $links_file 		>> $build_file
	txt2html $txt_file		>> $build_file
	cat assets/html.end.html 	>> $build_file

done

echo '*** copying files...'
cp -a assets/robots.txt			_build/
cp -a assets/favicon.ico 		_build/
cp -a txt/*				_build/

cp -a files/				_build/
cp -a benchmarks/			_build

echo '*** build done.'
