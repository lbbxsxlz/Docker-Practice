FROM ubuntu:16.04
LABEL maintainer="lbbxsxlz@gmail.com"
ENV REFRESHED_AT 2020-09-14
RUN apt-get -qq update
RUN apt-get install nginx
