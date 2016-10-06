# Let'sEncrypt Guide

Here you will found:
* auto-renewal scripts
* auto-renewal installation

## Content

* [Setup](#setup)
    * [Certificates creation](#certificates-bot)
    * [Cron](#cron)
    * [Nginx](#nginx)
* [TroubleShooting](#troubleshooting)

## Setup

* [Installing of CertBot could be found here](https://github.com/certbot/certbot)
    * scripts in this repo use this path for certbot: `/opt/certbot/`
* installing this config:
    * `git clone https://github.com/lgg/letsencrypt-config && cd letsencrypt-config`
    * `chmod +x ./install.sh`
    * `./install.sh`
    * set configs for:
        * cron
        * nginx
        * let's encrypt bot (`/usr/local/letssl/`)

### Certificates bot

* _(optional)_ create [aliases](./aliases.md)
* you can use `./install.sh` script or do it manually
    * `mkdir /etc/letssl`
    * paste files from repo's `/etc/letssl/` to your server `/etc/letssl/`
    * add execution right for scripts `chmod +x run_letsencrypt && chmod +x update_ssl`
    * `mkdir /usr/local/letssl`
    * paste `config-sample.ini` from repo to your server
    * rename it to `mv config-sample.ini sample`
    * copy it `cp sample site.com.ini`
* edit your config file(**IMPORTANT: config files should be with .ini extension**) `vi site.com.ini`
* **!IMPORTANT!** you will need to run certbot manually for the first time
    to install needed dependencies:     
    `/opt/certbot/certbot-auto certonly -a webroot --agree-tos --renew-by-default --config /usr/local/letssl/site.com.ini`
* if previous step is successfully -> create cron task

### Cron

* under root: `crontab -e`
* add task:
```
# m h  dom mon dow   command
0 0 */5 * * /etc/letssl/update_ssl >> /var/log/letssl/update2.log
```
* this will renew check certificates for renewal every 5 days
* expiration limit is set in `/etc/letssl/run_letsencrypt` on 7 line(`exp_limit=40;`)

### Nginx

Here is a sample for nginx configs, e.g. we have `site.com`:
* `vi /etc/nginx/sites-available/site.com`
* for forcing https:
```
server {
        listen 80;
        server_name site.com;
        # enforce https
        return 301 https://$server_name$request_uri;
}
server {
        listen 443 ssl;
        server_name site.com;

        # Add https strict header
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload;";
```
* ssl config:
```
server {
        listen 443 ssl;
        server_name site.com;

        ssl_certificate /etc/letsencrypt/live/site.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/site.com/privkey.pem;
```
* if you use php, don't forget to add `fastcgi_param HTTPS on;` to your php section
* if you want to handle error(The plain HTTP request was sent to HTTPS port), when ssl is on another port(not 443) and somebody http://site.com:8888
```
# This will redirect to google.com in this case
error_page 497 https://google.com;
```

## TroubleShooting

* check logs:
    * `vi /var/log/letssl/update.log`
    * `vi /var/log/letssl/update2.log`
* check if `site.com/.well-known/` is accessible
    * if not - allow it in your webservers's config
* try to run it manually
* check your certificates and pathes in webserver's configs
* check your params
* search for your error in google
* open issue and i hope i will able to help you

## License

* MIT
* 2016, lgg