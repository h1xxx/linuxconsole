#!/bin/mksh

set -euo pipefail

rsync -avP --delete build root@vm0://var/www/linuxconsole.net

ssh root@vm0 chown -R root:nginx /var/www/linuxconsole.net
ssh root@vm0 chmod 750 /var/www/linuxconsole.net
ssh root@vm0 chmod 640 /var/www/linuxconsole.net/*
