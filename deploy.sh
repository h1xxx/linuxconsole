#!/bin/ksh

set -eu


deploy()
{
       rsync -avP --checksum \
		--no-perms --no-owner --no-group \
		build/ root@www://var/www/linuxconsole.net/

       ssh root@www chown -c -R root:nginx /var/www/linuxconsole.net
       ssh root@www chmod -c 750 /var/www/linuxconsole.net
       ssh root@www chmod -c 640 /var/www/linuxconsole.net/*
       ssh root@www chmod -c 755 /var/www/linuxconsole.net/files
       ssh root@www chmod -c 755 /var/www/linuxconsole.net/benchmarks
       ssh root@www chmod -c 644 /var/www/linuxconsole.net/files/*
       ssh root@www chmod -c 644 /var/www/linuxconsole.net/benchmarks/*

       rsync -avP --checksum \
		--no-perms --no-owner --no-group \
		./ root@www://var/git/lnxcons/

       ssh root@www chown -c -R root:nobody /var/git/lnxcons
       ssh root@www 'find /var/git/lnxcons/ \
       		-type d \
		-exec chmod -c 750 {} \;'
       ssh root@www 'find /var/git/lnxcons/ \
       		-type f \
		-exec chmod -c 640 {} \;'

       exit 0
}


ssl_deploy_c()
{
       in=$(cat "$1")
       in=$(openssl enc -base64 <<< $in)
       len=${#in}

       for i in $(seq 0 $((len - 1))); do

               c=${in:$i:1}
               c_i=$(echo -n "${c}" | od -i -A n)
               c_i=$((c_i + 1))
               [ $c_i -lt 16 ] &&  c_x=$(printf "0x0%x\n" $c_i)
               [ $c_i -ge 16 ] &&  c_x=$(printf "0x%x\n" $c_i)
               echo -n "$c_x "

       done

       exit 0
}


ssl_deploy_d()
{
       in=$(cat "$1")
       o=''

       for c_x in $in; do
               c_x=$(sed 's/0x//g' <<< $c_x)
               c_x=$(tr 'a-z' 'A-Z' <<< $c_x)
               c_i=$(echo "ibase=16; $c_x" | bc)
               c_i=$((c_i - 1))
               c=$(printf "\x$(printf "%x" $c_i)")
               o=$o$c

       done
       #openssl enc -base64 -d <<< $o
       exit 0
}


[ $# -eq 0 ] && deploy
[ "$1" == "-c" ] && ssl_deploy_c $2
[ "$1" == "-d" ] && ssl_deploy_d $2
