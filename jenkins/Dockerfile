FROM jenkins/jenkins:lts
MAINTAINER lbbxsxlz@gmail.com
ENV REFRESHED_AT 2020-09-25

USER root
RUN apt-get -qq update && apt-get install -qq sudo
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz
RUN tar -xvzf docker-latest.tgz
RUN mv docker/* /usr/bin/
#COPY docker/* /usr/bin/

USER jenkins
RUN /usr/local/bin/install-plugins.sh junit git git-client ssh-slaves greenballs chucknorris ws-cleanup
