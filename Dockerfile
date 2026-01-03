FROM osrf/ros:jazzy-desktop-full
RUN userdel -r ubuntu

ARG UID=1000
ARG GID=1000
ARG CONTAINER_USER="ece5532"

RUN apt update && apt upgrade -y && apt-get install -y && apt-get install -y bc iputils-ping file ftp psmisc wget curl vim python3-pip lsb-release apt-transport-https ros-dev-tools ros-$ROS_DISTRO-rqt-tf-tree ros-$ROS_DISTRO-plotjuggler-ros && rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GID $CONTAINER_USER
RUN useradd -m -u $UID -g $GID -s /bin/bash $CONTAINER_USER && usermod -aG sudo $CONTAINER_USER && echo "$CONTAINER_USER:password" | chpasswd
SHELL ["/bin/bash", "-c"]

# Clone and install helper scripts
RUN git clone https://github.com/robustify/ros2_helper_scripts.git \
&& cp ros2_helper_scripts/*.bash /usr/bin \
&& rm -rf ros2_helper_scripts

RUN apt update

USER $CONTAINER_USER
RUN rosdep update
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source $HOME/ros/install/setup.bash" >> ~/.bashrc
RUN echo "export RCUTILS_COLORIZED_OUTPUT=1" >> ~/.bashrc

WORKDIR /home/$CONTAINER_USER/ros
CMD ["/bin/bash"]
