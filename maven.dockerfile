FROM prompto/centos:1.0.0
USER prompto
WORKDIR /home/prompto
RUN mkdir /home/prompto/.m2
ADD ./nexus-settings.xml /home/prompto/.m2/settings.xml
USER root
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install -y apache-maven
