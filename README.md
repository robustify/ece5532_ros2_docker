# ROS 2 Docker Setup for ECE 5532

## Installing Prerequisites

First, install Docker CE by following steps 1 through 3 from "Install using the `apt` repository" on this page: [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

In addition to Docker CE, in order to run the graphical ROS tools, the NVIDIA Container Toolkit is required.
The complete installation instructions can be found here: [https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

The relevant instructions are included in this README for your convenience:

1. Configure the production repository:
```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

2. Update `apt` and install the Toolkit packages:

```
sudo apt update && sudo apt install -y nvidia-container-toolkit
```

3. Configure the container runtime by using the `nvidia-ctk` command:

```
sudo nvidia-ctk runtime configure --runtime=docker
```

4. Restart the Docker daemon:

```
sudo systemctl restart docker
```

## Building the Image Locally

To build the image locally, run the `build.sh` script.

```
./build.sh
```

This should only have to be run once to create the image.

## Creating a Container and Attaching to It

The `run.sh` and `new_shell.sh` scripts in this repository automatically set things up for you.

`run.sh` creates the container instance with the appropriate settings.
You should only have to execute this script once to set up the container instance of the Docker image.

```
./run.sh
```

`new_shell.sh` attaches a bash shell instance to the running container to run commands from.
If the container does not exist or is not running when this script is run, it automatically runs `run.sh` to create and/or start it.

```
./new_shell.sh
```

## Developing Code in the Container

`run.sh` mounts the `ros` workspace folder in this repository on the host OS to the `/home/ece5532/ros` path in the image.
Simply put your source code in this workspace folder on the host OS and the container will be able to access it for building and running.

Using VS Code's Dev Container extension, the active VS Code window and terminals can be loaded in the container.
This makes using the Docker image to write and run software much more convenient and is highly recommended.

After a new container is created from `run.sh`, the supporting code repositories should be cloned into the ROS workspace folder.
This can be done from either the host OS, or from inside the container. From inside the container, running this command will clone the two repositories, and install any missing dependencies.

```
cd $HOME/ros/src \
&& git clone https://github.com/robustify/ece5532_gazebo.git \
&& git clone https://github.com/robustify/audibot.git -b gz_harmonic \
&& cd $HOME/ros && deps.bash
```

To compile the workspace, `cd` back to `$HOME/ros`, and run `release.bash`.

## ROS Bags

The `bags` folder in this repository is also mounted in the container, so by putting bags in this folder on the host OS, the container can run the bags.