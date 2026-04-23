#!/bin/bash

mkdir -p ./bin
cd ./bin

export OCP_VERSION="4.20.16"

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OCP_VERSION}/openshift-client-linux.tar.gz

tar zxvf openshift-client-linux.tar.gz
rm -f openshift-client-linux.tar.gz

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OCP_VERSION}/openshift-install-linux.tar.gz

tar zxvf openshift-install-linux.tar.gz
rm -f openshift-install-linux.tar.gz

rm README.md

wget https://github.com/coreos/butane/releases/download/v0.27.0/butane-x86_64-unknown-linux-gnu -O butane

chmod a+x butane
chmod a+x kubectl
chmod a+x oc
chmod a+x openshift-install

