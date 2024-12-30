#!/bin/bash

# https://docs.aws.amazon.com/en_us/parallelcluster/latest/ug/tutorials_11_running-containerized-jobs-with-pyxis.html

set -e

echo "Executing $0"

# Configure Enroot
ENROOT_PERSISTENT_DIR="/var/enroot"
ENROOT_VOLATILE_DIR="/run/enroot"

sudo mkdir -p $ENROOT_PERSISTENT_DIR
sudo chmod 1777 $ENROOT_PERSISTENT_DIR
sudo mkdir -p $ENROOT_VOLATILE_DIR
sudo chmod 1777 $ENROOT_VOLATILE_DIR
sudo cp /opt/parallelcluster/examples/enroot/enroot.conf /etc/enroot/enroot.conf
sudo chmod 0644 /etc/enroot/enroot.conf

# Configure Pyxis
PYXIS_RUNTIME_DIR="/run/pyxis"

sudo mkdir -p $PYXIS_RUNTIME_DIR
sudo chmod 1777 $PYXIS_RUNTIME_DIR

set -exo pipefail

mkdir -p /etc/sysconfig
wget -O /etc/chef/cookbooks/aws-parallelcluster-slurm/templates/default/compute_node_finalize/slurm/slurm.sysconfig.erb https://raw.githubusercontent.com/aws/aws-parallelcluster-cookbook/refs/heads/develop/cookbooks/aws-parallelcluster-slurm/templates/default/compute_node_finalize/slurm/slurm.sysconfig.erb
echo "PATH=/opt/slurm/sbin:/opt/slurm/bin:$(bash -c 'source /etc/environment ; echo $PATH')" >> /etc/chef/cookbooks/aws-parallelcluster-slurm/templates/default/compute_node_finalize/slurm/slurm.sysconfig.erb
