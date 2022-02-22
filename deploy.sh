#!/bin/ksh
set -eu

rsync -avP --checksum \
	--no-perms --no-owner --no-group \
	_build/ root@www://var/www/linuxconsole.net/

ssh root@www chown -c -R root:nginx /var/www/linuxconsole.net

ssh root@www chmod -c 750 /var/www/linuxconsole.net
ssh root@www chmod -c 640 /var/www/linuxconsole.net/*.*

ssh root@www chmod -c 755 /var/www/linuxconsole.net/files
ssh root@www chmod -c 644 /var/www/linuxconsole.net/files/*

ssh root@www chmod -c 755 /var/www/linuxconsole.net/benchmarks
ssh root@www chmod -c 755 /var/www/linuxconsole.net/benchmarks/*
ssh root@www chmod -c 644 /var/www/linuxconsole.net/benchmarks/compression/*.*

exit 0
