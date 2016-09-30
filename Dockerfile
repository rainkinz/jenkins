FROM jenkins:2.7.4
MAINTAINER Brendan Grainger

USER root

RUN apt-get update \
      && apt-get install -y sudo \
      && apt-get install -y vim \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# COPY plugins.txt /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
ENV JAVA_OPTS="-Xmx8192m"
#ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300"
#ENV JENKINS_UC_DOWNLOAD="https://updates.jenkins-ci.org/download"

RUN install-plugins.sh git:2.6.0
RUN /usr/local/bin/install-plugins.sh amazon-ecr
RUN /usr/local/bin/install-plugins.sh docker-workflow
RUN /usr/local/bin/install-plugins.sh copyartifact
RUN /usr/local/bin/install-plugins.sh templateproject
RUN /usr/local/bin/install-plugins.sh logparser
RUN /usr/local/bin/install-plugins.sh workflowaggregator
RUN /usr/local/bin/install-plugins.sh workflowmultibranch

