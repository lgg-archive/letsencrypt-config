#!/bin/bash

# create dir for log files
mkdir /var/log/letssl/

# add logrotate config
cp ./etc/logrotate.d/letsencrypt /etc/logrotate.d/letsencrypt

# create /etc/letssl scripts
mkdir /etc/letssl/
cp ./etc/letssl/* /etc/letssl/
chmod +x /etc/letssl/run_letsencrypt && chmod +x /etc/letssl/update_ssl

# create config sample for let's encrypt
mkdir /usr/local/letssl/
cp ./usr/local/letssl/config-sample.ini /usr/local/letssl/