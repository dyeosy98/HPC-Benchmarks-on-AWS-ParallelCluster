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

### Install NVIDIA libnvidia-container

apt update

nvidia-smi && export GPU_PRESENT=0 || GPU_PRESENT=-1;
if [ $GPU_PRESENT -eq 0 ]; then
    nvidia-container-cli info && export GPU_CONTAINER_PRESENT=0 || export GPU_CONTAINER_PRESENT=-1
else
    export GPU_CONTAINER_PRESENT=1
fi

if [ $GPU_PRESENT -eq 0 ] && [ $GPU_CONTAINER_PRESENT -gt 0 ]; then
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  apt-get update -y
  apt-get install libnvidia-container-tools -y
fi
