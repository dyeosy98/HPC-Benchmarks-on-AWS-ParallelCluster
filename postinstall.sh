#!/bin/bash

set -exo pipefail

# Install nccl-tests
if [ ! -d "/opt/nvidia/nvidia_hpc_benchmarks_openmpi" ]; then
  wget https://developer.download.nvidia.com/compute/nvidia-hpc-benchmarks/24.09/local_installers/nvidia-hpc-benchmarks-local-repo-ubuntu2204-24.09_1.0-1_amd64.deb
  sudo dpkg -i nvidia-hpc-benchmarks-local-repo-ubuntu2204-24.09_1.0-1_amd64.deb
  sudo cp /var/nvidia-hpc-benchmarks-local-repo-ubuntu2204-24.09/nvidia-hpc-benchmarks-*-keyring.gpg /usr/share/keyrings/
  sudo apt-get update
  sudo apt-get -y install nvidia-hpc-benchmarks-openmpi
fi

# HEAD NODE: Enable Pyxis and Enroot on AWS ParallelCluster 3.11.1

set -e

echo "Executing $0"

# Configure Enroot
ENROOT_PERSISTENT_DIR="/var/enroot"
ENROOT_VOLATILE_DIR="/run/enroot"

sudo mkdir -p $ENROOT_PERSISTENT_DIR
sudo chmod 1777 $ENROOT_PERSISTENT_DIR
sudo mkdir -p $ENROOT_VOLATILE_DIR
sudo chmod 1777 $ENROOT_VOLATILE_DIR
sudo mv /opt/parallelcluster/examples/enroot/enroot.conf /etc/enroot/enroot.conf
sudo chmod 0644 /etc/enroot/enroot.conf

# Configure Pyxis
PYXIS_RUNTIME_DIR="/run/pyxis"

sudo mkdir -p $PYXIS_RUNTIME_DIR
sudo chmod 1777 $PYXIS_RUNTIME_DIR

sudo mkdir -p /opt/slurm/etc/plugstack.conf.d/
sudo mv /opt/parallelcluster/examples/spank/plugstack.conf /opt/slurm/etc/
sudo mv /opt/parallelcluster/examples/pyxis/pyxis.conf /opt/slurm/etc/plugstack.conf.d/
sudo -i scontrol reconfigure                        
                    
