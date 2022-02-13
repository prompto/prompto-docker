FROM prompto/maven:1.0.3
RUN yum -y install java-11-openjdk-devel
RUN echo 2 | alternatives --config java
ENV JAVA_HOME /etc/alternatives/java_sdk_11/
