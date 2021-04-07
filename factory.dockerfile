FROM prompto/platform:0.0.221
USER prompto
WORKDIR /home/prompto
ADD ./get-factory-version.py get-factory-version.py
RUN python get-factory-version.py >> factory-version.txt
RUN mvn dependency:get -Dartifact=org.prompto:CodeFactory:$(cat factory-version.txt)
USER root
RUN mkdir /v$(cat factory-version.txt) && chown prompto:prompto /v$(cat factory-version.txt)
USER prompto
RUN echo /home/prompto/.m2/repository/org/prompto/CodeFactory/$(cat factory-version.txt)/CodeFactory-$(cat factory-version.txt) >> prefix.txt
RUN mvn dependency:copy-dependencies -f $(cat prefix.txt).pom -DoutputDirectory=/v$(cat factory-version.txt)
RUN cp $(cat prefix.txt).jar /v$(cat factory-version.txt)/
