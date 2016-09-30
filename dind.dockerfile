FROM jenkins:2.7.4
MAINTAINER Brendan Grainger

USER root

# RUN apt-get update -qq \
#       && apt-get install -y sudo \
#       && apt-get install -y vim \
#       && rm -rf /var/lib/apt/lists/*
# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    sudo \
    vim \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the wrapper script from https://raw.githubusercontent.com/docker/docker/master/hack/dind.
ADD ./dind /usr/local/bin/dind
RUN chmod +x /usr/local/bin/dind

ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker

RUN usermod -aG docker jenkins

USER jenkins

# RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
# COPY plugins.txt /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
ENV JAVA_OPTS="-Xmx8192m"
#ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300"
#ENV JENKINS_UC_DOWNLOAD="https://updates.jenkins-ci.org/download"

# USER root
# RUN install-plugins.sh multiple-scms
# RUN install-plugins.sh git:2.6.0
# RUN /usr/local/bin/install-plugins.sh amazon-ecr
# RUN /usr/local/bin/install-plugins.sh docker-workflow
# RUN /usr/local/bin/install-plugins.sh copyartifact
