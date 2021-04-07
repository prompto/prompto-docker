FROM prompto/centos:1.0.0
USER root
ADD ./mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo
RUN yum install -y mongodb-org
ADD ./mongod.conf /etc/mongod.conf
ADD ./mongo.sh /mongo.sh
RUN chmod 777 /mongo.sh
VOLUME /mnt/prompto
EXPOSE 27017
ENTRYPOINT ["/mongo.sh"]
CMD ["*"]