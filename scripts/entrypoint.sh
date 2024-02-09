#!/bin/sh

set -e        #it will throw error if some command fails in the script

# Original Line: here seems to be a small typo in the command. probably the next is the correct command.
# envsubst < /etc/nginx/default.conf.tpl / /etc/nginx/conf.d/defualt.conf

# the template file (/etc/nginx/conf.d/default.conf.tpl) contains the environment variables you want to substitute, and the default.conf file will be generated with those variables replaced by their corresponding values.
envsubst < /etc/nginx/conf.d/default.conf.tpl > /etc/nginx/conf.d/default.conf



#start the nginx in docker but not in background
nginx -g 'daemon off;'


