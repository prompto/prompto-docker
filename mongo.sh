#!/bin/bash
mkdir -p /mnt/prompto/log/mongo && chown mongod:mongod /mnt/prompto/log/mongo
mkdir -p /mnt/prompto/data/mongo && chown mongod:mongod /mnt/prompto/data/mongo
./usr/bin/mongod --config /etc/mongod.conf