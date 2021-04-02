FROM prompto/platform:latest
ADD . get-factory-version.py
RUN python get-factory-version.py >> factory-version.txt
RUN mvn dependency:get -Dartifact=org.prompto:CodeFactory:$(cat factory-version.txt)