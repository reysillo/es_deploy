FROM ubuntu:14.04

RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y vim nano git wget libfreetype6 libfontconfig bzip2 supervisor zip unzip openssh-server && \
  mkdir -p /srv/var /var/log/supervisor /opt

# ---------------- Configuring ssh login container -----------------------------
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:3asyso1' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


# ----------------------- Install Java 7. ------------------------------------
RUN \
  apt-get update && \
  apt-get install -y openjdk-7-jdk && \
  rm -rf /var/lib/apt/lists/*

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable

# -------------- Git instalation ---------------------------
RUN \
	apt-get update && \
	sudo apt-get install git

# -------------------- Configurin gitlab SSH key access ----------------
#RUN mkdir /home/.ssh
ADD .ssh /root/.ssh/

# --------------------- Add Jenkins Slave ----------------------

RUN \
	mkdir /var/jenkins-slave

ADD jenkins-slave /var/jenkins-slave/

# --------------------------- execute jenkins slave -------

#RUN cd /var/jenkins-slave
RUN echo "source /var/jenkins-slave/jenkins-slave-shel.sh" >> /etc/bash.bashrc
#CMD sh jenkins-slave-shel.sh

# --------------------------------- MAVEN instalation ----------------------------
RUN \
	mkdir /usr/maven

ADD apache-maven-3.3.3 /usr/maven/

# ----------------------------- ENV VARIABLES ------------------------------

RUN \
	echo 'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64' >> /etc/bash.bashrc && \
	echo 'export M2_HOME=/usr/maven' >> /etc/bash.bashrc && \
	echo 'export M2=$M2_HOME/bin' >> /etc/bash.bashrc && \
	echo 'export PATH=$M2:$PATH' >> /etc/bash.bashrc