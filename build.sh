#!/bin/ksh
set -eu

txt2html()
{
	sed 's|&|\&amp;|g' $1 	|
	sed 's|<|\&lt;|g'  	|
	sed 's|>|\&gt;|g' 	|
	sed "s|'|\&#39;|g"	|
	sed 's|"|\&quot;|g'
}

add_hrefs()
{
	FILE=$1
	LINKS=$(grep '^\[x[0-f]\{2\}\]' "${FILE}" || :)

	for reflink in $LINKS; do

		ref=$(echo ${reflink} | cut -d':' -f1 | cut -c 3,4)
		link=$(echo ${reflink} | cut -d':' -f2-)

		# remove lines with link references
		regex="^\[x$ref\]"
		sed -i "/$regex/d" ${FILE}

		# extract a word to be replaced with href
		regex="[-_a-zA-Z0-9]*\[x$ref\]"
		word=$(grep -o "$regex" ${FILE} | cut -d'[' -f1)

		# create html hrefs
		href="<a href=\"$link\">$word</a>"
		sed -i "s|$regex|$href|g" ${FILE}
	done
}

get_index_h2() {
	FILE=$1
	awk '/^Index:/{printf $0 RS}' RS='\n\n' $FILE |
		grep -v -e '^Index:$' -e '^$' -e '^  - ' |
		sed 's|^\* ||g'
}

get_index_h3() {
	FILE=$1
	awk '/^Index:/{printf $0 RS}' RS='\n\n' $FILE |
		grep -v -e '^Index:$' -e '^$' |
		grep '^  - ' |
		sed 's|^  - ||g'
}

add_h1() {
	FILE=$1
	sed -i	-e '0,/^====*/ s|^====*$|<h1>&|' \
		-e '0,/^====*/ s|^====*$|&</h1>|' ${FILE}
}

add_h2() {
	FILE=$1
	get_index_h2 ${FILE} | while read -r l; do
		grep -q "^${l}$" ${FILE} || echo "ERROR: index not found: ${l}"
		sed -i	-e "s|^${l}$|<h2><span id=\"${l}\">${l}</span>|"\
			-e "s|^\* ${l}$|<a href=\"#${l}\">\* ${l}</a>|" ${FILE}
	done
	sed -i 's|^====*$|&</h2>|' ${FILE}
}

add_h3() {
	FILE=$1
	get_index_h3 ${FILE} | while read -r l; do
		grep -q "^${l}$" ${FILE} || echo "ERROR: index not found: ${l}"
		sed -i	-e "s|^${l}$|<h3><span id=\"${l}\">${l}</span>|"\
			-e "s|^  - ${l}$|<a href=\"#${l}\">  - ${l}</a>|" ${FILE}
	done
	sed -i 's|^----*$|&</h3>|' ${FILE}
}


echo '*** cleaning old build...'
[ -d _build ] && rm -r _build
mkdir -p _build

for txt_file in txt/*.txt; do
	
	name=$(basename $txt_file .txt)
	build_file="_build/${name}.html"

	echo "*** building ${name}..."

	links_file="assets/links.${name}.html"
	[ ! -f ${links_file} ] && links_file='assets/links.back.html'

	cat assets/html.header.html 			> $build_file
	sed "s/www.txt/${name}.txt/g" $links_file  	>> $build_file
	txt2html $txt_file				>> $build_file
	cat assets/html.end.html 			>> $build_file
	add_hrefs					$build_file
	add_h1						$build_file
	add_h2						$build_file
	add_h3						$build_file

	touch -d "$(git log -1 --format="%aD" -- "$txt_file")" $build_file
done

echo '*** copying files...'
cp -a assets/robots.txt			_build/
cp -a assets/favicon.ico 		_build/
cp -a txt/*				_build/

cp -a files/				_build/
cp -a benchmarks/			_build

echo '*** build done.'
