FROM prompto/platform:0.0.221
USER root
ADD ./mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo
RUN yum install -y mongodb-org-tools
