FROM centos:centos7.4.1708

MAINTAINER ketchLiu <bjliu0608@163.com>

ARG VERSION=3.35
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

USER root

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (agent.jar)" Vendor="Jenkins project" Version="${VERSION}"

ARG AGENT_WORKDIR=/home/${user}/agent

RUN yum install -y java-1.8.0-openjdk maven curl git git-lfs libtool-ltdl-devel \
  && yum clean all \
  && rm -rf /var/cache/yum/* \ 
  && mkdir -p /usr/share/jenkins/
    

COPY remoting-2.19.jar /usr/share/jenkins/slave.jar
COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar \
  && chmod +x /usr/local/bin/jenkins-agent \
  && ln -sf /usr/share/jenkins/slave.jar /usr/share/jenkins/agent.jar \
  && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
WORKDIR /home/${user}

ENTRYPOINT ["jenkins-agent"]
