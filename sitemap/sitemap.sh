#!/bin/mksh

python main.py -v --domain https://linuxconsole.net --output sitemap.xml

rsync -avP sitemap.xml root@vm0://var/www/linuxconsole.net/


