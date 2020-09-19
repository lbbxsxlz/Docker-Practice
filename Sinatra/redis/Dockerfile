FROM ubuntu:16.04
LABEL maintainer="lbbxsxlz@gmail.com"
ENV REFRESHED_AT 2020-09-19

RUN apt-get -qq update && apt-get -qq install redis-server redis-tools

EXPOSE 6379

ENTRYPOINT ["/usr/bin/redis-server" ]
CMD []
