# ROS Melodic
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get upgrade
sudo apt install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake
sudo rosdep init
rosdep update
mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws
rosinstall_generator ros_comm --rosdistro melodic --deps --wet-only --tar > melodic-ros_comm-wet.rosinstall
wstool init src melodic-ros_comm-wet.rosinstall
rosdep install -y --from-paths src --ignore-src --rosdistro melodic -r --os=debian:buster
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/melodic
source /opt/ros/melodic/setup.bash
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
rosinstall_generator ros_comm ros_control joystick_drivers --rosdistro melodic --deps --wet-only --tar > melodic-custom_ros.rosinstall
wstool merge -t src melodic-custom_ros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro melodic -y -r --os=debian:buster
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/melodic

# MAVLINK/MAVROS master
cd ~
sudo apt-get install python-catkin-tools python-rosinstall-generator -y
mkdir -p ~/catkin_build_ws/src
cd catkin_build_ws/
catkin init
wstool init src
rosinstall_generator --rosdistro kinetic mavlink | tee /tmp/mavros.rosinstall
rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src -j2
rosdep install --from-paths src --ignore-src --rosdistro melodic -y -r --os=debian:buster
rosinstall_generator --rosdistro melodic geographic_msgs | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic uuid_msgs | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic angles | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic eigen_conversions | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic orocos_kdl | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic nav_msgs | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic tf2_eigen | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic tf2 | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic tf2_msgs | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic tf2_ros | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic tf2_py | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic trajectory_msgs | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic tf | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic visualization_msgs | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic control_toolbox | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic control_msgs | tee -a /tmp/mavros.rosinstall 
rosinstall_generator --rosdistro melodic dynamic_reconfigure | tee -a /tmp/mavros.rosinstall 
wstool merge -t src /tmp/mavros.rosinstall 
wstool update -t src -j2
sudo ./src/mavros/mavros/scripts/install_geographiclib_datasets.sh
catkin build
sudo usermod -a -G dialout $USER
