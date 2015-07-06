#!/bin/sh

/etc/init.d/nginx start

IP=`ip addr| grep 172 | awk '{print $2}'| cut -f1 -d '/'`
echo "Open your browser at http://$IP"

DIR=`dirname $0`

$DIR/server.pl &
$DIR/apiendpoint.pl
