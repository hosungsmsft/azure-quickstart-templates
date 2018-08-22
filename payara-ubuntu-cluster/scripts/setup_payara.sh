#!/bin/bash

apt -y update
apt -y upgrade
apt -y install openjdk-8-jdk-headless unzip

for arg in "$@"; do
    echo $arg >> /tmp/args.txt
done
