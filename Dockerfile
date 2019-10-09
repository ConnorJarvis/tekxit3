# This Dockerfile is used to build an image containing Minecraft Tekkit
FROM ubuntu:xenial
MAINTAINER Rizbe


# Make sure the package repository is up to date.
RUN apt update
RUN apt -y upgrade

#Install Java
RUN apt install unzip wget  -y

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y wget unzip sudo git-core && \
  wget https://raw.githubusercontent.com/chrishantha/install-java/master/install-java.sh && \
  wget https://b2.vangel.io/file/vangel-cdn/jdk-8u211-linux-x64.tar.gz && \
  chmod +x install-java.sh && \
  yes | sudo ./install-java.sh -f jdk-8u211-linux-x64.tar.gz


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/jdk1.8.0_211


# Add user minecraft
RUN adduser --quiet minecraft
RUN mkdir /opt/tekkit
RUN chown -R minecraft /opt/tekkit


#Download Tekkit Legends
RUN wget -O /tmp/tekkit.zip https://www.tekx.it/downloads/0.96Tekxit3Server.zip
RUN unzip /tmp/tekkit.zip -d /opt/tekkit
RUN wget -O /opt/tekkit/0.96Tekxit3Server/start.sh https://f001.backblazeb2.com/file/vangel-cdn/start.sh
RUN chmod +x /opt/tekkit/0.96Tekxit3Server/start.sh
RUN chmod +x /opt/tekkit/0.96Tekxit3Server/forge-1.12.2-14.23.5.2824-universal.jar
RUN chown -R minecraft /opt/tekkit

VOLUME ["/opt/tekkit"]
EXPOSE 25565

WORKDIR /opt/tekkit
USER minecraft
ENTRYPOINT ["/bin/sh","/opt/tekkit/0.96Tekxit3Server/start.sh"]