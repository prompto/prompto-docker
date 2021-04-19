#!/bin/bash
VERSION=$(cat factory-version.txt)
cd /v${VERSION} || return
java -jar CodeFactory-${VERSION}.jar -yamlConfigFile /home/prompto/factory-config.yml