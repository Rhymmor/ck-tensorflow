#! /bin/bash

#
# Installation script for Tensorflow.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.


# PACKAGE_DIR
# INSTALL_DIR

echo "**************************************************************"
echo "Preparing vars for Tensorflow ..."

cd ${INSTALL_DIR}/src
MAKEFILE_DIR=tensorflow/contrib/makefile

################################################################################################

if [ ! -d "${MAKEFILE_DIR}/downloads" ]; then
    ${MAKEFILE_DIR}/download_dependencies.sh
    if [ "${?}" != "0" ]; then
        echo ""
        echo "Error: Downloading dependencies for '${CK_ENV_LIB_TF}/src/${MAKEFILE_DIR}' failed!"
        exit 1
    fi
fi

################################################################################################

if [ ! -d "${MAKEFILE_DIR}/gen/protobuf" ]; then
    tensorflow/contrib/makefile/compile_linux_protobuf.sh -c
    if [ "${?}" != "0" ] ; then
        echo ""
        echo "Error: Compiling linux protobuf for '${CK_ENV_LIB_TF}/src/${MAKEFILE_DIR}' failed!"
        exit 1
    fi
fi

make -f ${MAKEFILE_DIR}/Makefile