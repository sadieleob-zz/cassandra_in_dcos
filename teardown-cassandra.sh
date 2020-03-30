#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' #No Color
GREEN='\e[32m'
BLINK='\e[5m'

# Delete Cassandra
dcos package uninstall cassandra --yes &> /dev/null

Is_Cassandra_Uninstalled=`dcos marathon app show /cassandra`
dcos marathon app show /cassandra &> /dev/null

until [[ $? -eq "1" ]]; do
	printf "${BLINK}${RED}Uninstalling Cassandra${NC}\n"
	sleep 30
	dcos marathon app show /cassandra &> /dev/null
done

printf "${RED}Cassandra has been uninstalled${NC}\n"

# Delete Kubernetes Cluster Service Account
dcos security org service-accounts delete cassandra
dcos security secrets delete cassandra/cassandra-secret

printf "${RED}Cassandra service account and permissions have been deleted${NC}\n"

