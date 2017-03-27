#! /bin/bash

#
# Installation script for Tensorflow.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.


# PACKAGE_DIR
# INSTALL_DIR

cd ${INSTALL_DIR}/src && ./configure

if [ "${?}" != "0" ] ; then
  echo "Error: Configure failed!"
  exit 1
fi

cd ${INSTALL_DIR}/src && bazel build tensorflow/examples/label_image

if [ "${?}" != "0" ] ; then
  echo "Error: bazel build failed!"
  exit 1
fi