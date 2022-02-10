FROM prompto/centos:1.0.0
RUN yum -y install java-11-openjdk-devel
ENV JAVA_HOME /etc/alternatives/java_sdk_11/
