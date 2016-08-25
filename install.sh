#!/bin/bash

# create dir for log files
mkdir /var/log/letssl/

# add logrotate config
cp ./etc/logrotate.d/logrotate_config /etc/logrotate.d/letsencrypt

# create /etc/letssl scripts
mkdir /etc/letssl/
cp ./etc/letssl/* /etc/letssl/

# create config sample for let's encrypt
mkdir /usr/local/letssl/
cp ./usr/local/letssl/config-sample.ini /usr/local/letssl/