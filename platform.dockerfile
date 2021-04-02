FROM prompto/maven:1.0.0
USER prompto
WORKDIR /home/prompto
ADD ./get-platform-version.py get-platform-version.py
RUN python get-platform-version.py >> platform-version.txt
RUN mvn dependency:get -Dartifact=org.prompto:Server:$(cat platform-version.txt)