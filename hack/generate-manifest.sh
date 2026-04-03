#!/bin/bash

# Exit on error
set -e

# Where are we pulling cluster configuration from - make a `clusters` directory and store your config there, it's in .gitignore
SITE_CONFIG_DIR="${SITE_CONFIG_DIR:-examples}"
#SITE_CONFIG_DIR="clusters"

# Check to see if there was an argument passed for the cluster config
if [ -z "$1" ]; then
    echo "No site config folder specified"
    exit 1
fi

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Download the binaries
if [ ! -d "bin" ] || [ ! -f "bin/openshift-install" ] || [ ! -f "bin/oc" ]; then
    ./download-openshift-cli.sh
fi

cd $SCRIPT_DIR/..

# Check that the cluster name exists
if [ ! -d "${SITE_CONFIG_DIR}/$1" ]; then
    echo "No site config folder found for $1"
    echo "Found these site config folders:"
    ls -1 ${SITE_CONFIG_DIR}
    exit 1
fi

# Get the cluster_name
CLUSTER_NAME=$(grep "cluster_name" ${SITE_CONFIG_DIR}/${1}/cluster.yml | awk '{print $2}' | tr -d '"')
# Get the base_domain
BASE_DOMAIN=$(grep "base_domain" ${SITE_CONFIG_DIR}/${1}/cluster.yml | awk '{print $2}' | tr -d '"')

# Display header
echo "============================================================="
echo "Generating manifest for cluster:"
echo " ${CLUSTER_NAME}"
echo "============================================================="
echo -e "\n - Templating the manifests for the cluster..."

# Run the templating playbook
ansible-playbook -e "@${SITE_CONFIG_DIR}/${1}/cluster.yml" -e pull_secret_path="$(realpath ./${SITE_CONFIG_DIR}/${1}/ocp-install-pull-secret.json)" -e "@${SITE_CONFIG_DIR}/${1}/nodes.yml" playbooks/create-manifests.yml

# Generate the ABI ISO
echo "============================================================="
echo -e "\nGenerating manifest ...\n"
#./bin/openshift-install agent create image --dir ./playbooks/generated_manifests/${CLUSTER_NAME}/

# Display footer
echo -e "\nManifest generated successfully!"
echo "Location: ./playbooks/generated_manifests/${CLUSTER_NAME}"
