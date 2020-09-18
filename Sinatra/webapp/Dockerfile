FROM ubuntu:16.04
LABEL maintainer="lbbxsxlz@gmail.com"
ENV REFRESHED_AT 2020-09-18

RUN apt-get -qq update && apt-get -qq install ruby ruby-dev build-essential redis-tools
RUN gem install --no-rdoc --no-ri sinatra json redis

RUN mkdir -p /opt/webapp

EXPOSE 4567

CMD [ "/opt/webapp/bin/webapp" ]
