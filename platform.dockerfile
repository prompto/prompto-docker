FROM prompto/jdk11:1.0.0
USER prompto
WORKDIR /home/prompto
ADD ./get-platform-version.py get-platform-version.py
RUN python get-platform-version.py >> platform-version.txt
RUN mvn dependency:get -Dartifact=org.prompto:Server:$(cat platform-version.txt)
RUN mvn dependency:get -Dartifact=org.prompto:AwsClient:$(cat platform-version.txt)
RUN echo /home/prompto/.m2/repository/org/prompto/AwsClient/$(cat platform-version.txt)/AwsClient-$(cat platform-version.txt) >> AwsClient-prefix.txt
USER root
RUN mkdir /AwsClient && chown prompto:prompto /AwsClient
USER prompto
RUN mvn dependency:copy-dependencies -f $(cat AwsClient-prefix.txt).pom -DoutputDirectory=/AwsClient
RUN cp $(cat AwsClient-prefix.txt).jar /AwsClient/
