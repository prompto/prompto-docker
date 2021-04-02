FROM centos:7
RUN yum -y update
RUN yum clean all
RUN yum install -y wget
RUN useradd -m prompto
