FROM prompto/maven:1.0.3
RUN yum -y install epel-release
RUN yum -y install java-latest-openjdk
RUN echo 2 | alternatives --config java
ENV JAVA_HOME /etc/alternatives/jre_17_openjdk/
