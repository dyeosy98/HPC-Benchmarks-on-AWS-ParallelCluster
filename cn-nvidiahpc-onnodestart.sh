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
