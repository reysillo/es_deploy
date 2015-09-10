FROM ubuntu:14.04

MAINTAINER Reinaldo Calderón

# Commands

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y vim nano git wget libfreetype6 libfontconfig bzip2 supervisor zip unzip openssh-server make g++ patch zlib1g-dev libgif-dev && \
  mkdir -p /srv/var /var/log/supervisor /opt

ENV TOMCAT_VERSION 7.0.59
ENV TOMCAT_PORT 8080
ENV TOMCAT_PATH /opt/tomcat
ENV ACTIVEMQ_VERSION 5.10.0
ENV ACTIVEMQ_PATH /opt/activemq

# ----------- Install java 7 -------------#
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN apt-get -y install oracle-java7-installer
RUN apt-get install oracle-java7-set-default

# ----------- Install Tomcat -------------#
RUN \
  wget -O /tmp/tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-7/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
  cd /tmp && \
  tar zxf /tmp/tomcat.tar.gz && \
  ls /tmp && \
  mv /tmp/apache-tomcat* $TOMCAT_PATH && \
  rm -rf $TOMCAT_PATH/webapps/*.* && \
  rm -rf $TOMCAT_PATH/webapps/* && \
  rm /tmp/tomcat.tar.gz

EXPOSE $TOMCAT_PORT
EXPOSE 1317
EXPOSE 22

# ----------- Configure SSH -------------
RUN echo deb http://archive.ubuntu.com/ubuntu trusty main universe > /etc/apt/sources.list.d/trusty.list

# Clean
RUN \
  apt-get autoremove -y && \
  apt-get clean all && \
  /etc/init.d/ssh restart

# Set ssh service passwors
RUN echo 'root:3asyso1' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Files
ADD tomcat_supervisord_wrapper.sh $TOMCAT_PATH/bin/tomcat_supervisord_wrapper.sh
RUN chmod 755 $TOMCAT_PATH/bin/tomcat_supervisord_wrapper.sh

# ----------- Install swftool -----------
# RUN add-apt-repository -y ppa:guilhem-fr/swftools
RUN apt-get -y install swftools

# ----------- Install WHOIS -------------
# RUN add-apt-repository -y ppa:nathan-renniewaldock/ppa
RUN apt-get -y install whois

# Start
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]


