#!/usr/bin/env sh

if [ $# -gt 0 ];then
    # If we passed a command, run it as root
    exec "$@"
else
    # Otherwise start the web server
    chown -R webuser:webgroup /var/www/html

    exec /init
fi
