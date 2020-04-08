#!/bin/ksh
set -eu

html=$(curl -s $1)
html=$(echo "$html" | awk '/div class="content-wrapper"/{printf $0 RS}' RS='\n\n')
title=''

# list of patterns to look for
p_link="*href*"
p_title='*<span dir="ltr" class="title"*'

echo "$html" | while read -r line; do

	case "${line}" in
		$p_link)	echo -n https://www.youtube.com
				echo $line | cut -d'"' -f2 ;;
		$p_title)	title='true'
				continue ;;
	esac

	if [ "$title" == 'true' ]; then
		title=$line
		echo $line | w3m -dump -T text/html | head -n1
		title=''
	fi
done | paste -d' ' - -
