ARG PLATFORM_VERSION
FROM prompto/platform:$PLATFORM_VERSION
USER root
ADD ./mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo
RUN yum install -y mongodb-org-tools
USER prompto
WORKDIR /home/prompto
ADD ./get-factory-version.py get-factory-version.py
RUN python get-factory-version.py >> factory-version.txt
RUN mvn dependency:get -DincludeScope=compile -Dartifact=org.prompto:CodeFactory:$(cat factory-version.txt)
USER root
RUN mkdir /v$(cat factory-version.txt) && chown prompto:prompto /v$(cat factory-version.txt)
USER prompto
RUN echo /home/prompto/.m2/repository/org/prompto/CodeFactory/$(cat factory-version.txt)/CodeFactory-$(cat factory-version.txt) >> CodeFactory-prefix.txt
RUN mvn dependency:copy-dependencies -DincludeScope=compile -DoutputDirectory=/v$(cat factory-version.txt) -f $(cat CodeFactory-prefix.txt).pom
RUN cp $(cat CodeFactory-prefix.txt).jar /v$(cat factory-version.txt)/
ADD ./factory-config.yml factory-config.yml
ADD ./factory.sh factory.sh
USER root
RUN chmod 777 factory.sh
USER prompto
EXPOSE 80
EXPOSE 8000
ENTRYPOINT /home/prompto/factory.sh
CMD ["*"]
