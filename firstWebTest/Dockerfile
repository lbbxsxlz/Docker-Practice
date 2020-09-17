FROM lbbxsxlz/ubuntu_16.04
LABEL maintainer="lbbxsxlz@gmail.com"

RUN mkdir -p /var/www/html
ADD nginx/global.conf /etc/nginx/conf.d/
ADD nginx/nginx.conf /etc/nginx/

EXPOSE 80
