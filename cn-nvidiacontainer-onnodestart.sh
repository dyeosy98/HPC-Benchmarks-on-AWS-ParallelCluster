#!/bin/bash

### Install NVIDIA libnvidia-container

apt update

nvidia-smi && export GPU_PRESENT=0 || GPU_PRESENT=-1;
if [ $GPU_PRESENT -eq 0 ]; then
    nvidia-container-cli info && export GPU_CONTAINER_PRESENT=0 || export GPU_CONTAINER_PRESENT=-1
else
    export GPU_CONTAINER_PRESENT=1
fi

if [ $GPU_PRESENT -eq 0 ] && [ $GPU_CONTAINER_PRESENT -lt 0 ]; then
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  apt-get update -y
  apt-get install libnvidia-container-tools -y
fi

nvidia-container-cli --load-kmods info || true
