FROM ubuntu:16.04
LABEL maintainer="lbbxsxlz@gmail.com"
#ENV REFRESHED_AT 2020-09-14
RUN apt-get update
RUN apt-get -y install nginx
RUN echo 'Hello, i am in your first container' > /user/share/nginx/html/index.html
EXPOSE 80

