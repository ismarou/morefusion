#!/bin/bash

OBJSLAMPP_PREFIX=$HOME/ros_objslampp/src/objslampp
ROSOBJSLAMPP_PREFIX=$HOME/ros_objslampp

if [ ! -d $OBJSLAMPP_PREFIX ]; then
  echo "Please install objslampp to $OBJSLAMPP_PREFIX"
  exit 1
fi

if [ ! -e $OBJSLAMPP_PREFIX/.anaconda3/bin/activate ]; then
  echo "Please run 'make install' in objslampp"
  exit 1
fi

source $OBJSLAMPP_PREFIX/.anaconda3/bin/activate

set -x

pip install catkin_pkg
pip install rospkg
pip install empy

mkdir -p $ROSOBJSLAMPP_PREFIX/src
cd $ROSOBJSLAMPP_PREFIX
catkin init

if [ ! -e $ROSOBJSLAMPP_PREFIX/.autoenv.zsh ]; then
  cp $OBJSLAMPP_PREFIX/ros/template.autoenv.zsh $ROSOBJSLAMPP_PREFIX/.autoenv.zsh
fi
if [ ! -e $ROSOBJSLAMPP_PREFIX/.autoenv_leave.zsh ]; then
  cp $OBJSLAMPP_PREFIX/ros/template.autoenv_leave.zsh $ROSOBJSLAMPP_PREFIX/.autoenv_leave.zsh
fi

catkin config -DPYTHON_EXECUTABLE=$OBJSLAMPP_PREFIX/.anaconda3/bin/python \
              -DPYTHON_INCLUDE_DIR=$OBJSLAMPP_PREFIX/.anaconda3/include/python3.7m \
              -DPYTHON_LIBRARY=$OBJSLAMPP_PREFIX/.anaconda3/lib/libpython3.7m.so
mkdir -p $ROSOBJSLAMPP_PREFIX/devel/lib/python3/dist-packages
ln -fs $OBJSLAMPP_PREFIX/.anaconda3/lib/python3.7/site-packages/cv2 $ROSOBJSLAMPP_PREFIX/devel/lib/python3/dist-packages

catkin build cv_bridge

python -c 'import cv2'
python -c 'from cv_bridge.boost.cv_bridge_boost import getCvType'
