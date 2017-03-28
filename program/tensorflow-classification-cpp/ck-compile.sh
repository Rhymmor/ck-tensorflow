#! /bin/bash
TMP_DIR=$(pwd)
PROGRAM_DIR=$(dirname $PWD)

TARGET_SRC=classification

if [ ! -z ${CK_ANDROID_NDK_PLATFORM} ]; then
    #sudo apt-get install autoconf automake libtool curl make g++ unzip zlib1g-dev
   
    make -f ${MAKEFILE_DIR}/Makefile TARGET=ANDROID ANDROID_ARCH=${CK_ANDROID_ABI}
    if [ "${?}" != "0" ] ; then
        echo ""
        echo "Error: make for android classification failed!"
        exit 1
    fi

    cp ${CK_ENV_LIB_TF}/src/${MAKEFILE_DIR}/gen/bin/benchmark ${TMP_DIR}/classification
else
    GCC_FLAGS=""
    
    echo ""
    echo ""
    echo ---------------------------------------------------------------------------
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_TOOLS = ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_TOOLS}
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS_EIGEN = ${CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS_EIGEN}
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTO = ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTO}
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS = ${CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS}
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS_GEMMLOWP = ${CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS_GEMMLOWP}
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOTEXT = ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOTEXT}
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOTEXT = ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOTEXT}
    echo CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOBUF_HOST_INCUDE = ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOBUF_HOST_INCUDE}
    echo ---------------------------------------------------------------------------
    echo ""
    echo ""
    

    cd ${PROGRAM_DIR} && gcc --std=c++11 -DIS_SLIM_BUILD -fno-exceptions -DNDEBUG -O2 -march=native -fPIC -MT ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_TOOLS}/${TARGET_SRC}.o -MMD -MP -MF ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_TOOLS}/${TARGET_SRC}.Td -I. -I${CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS} -I${CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS_EIGEN} -I${CK_ENV_LIB_TF_MAKEFILE_DIR_DOWNLOADS_GEMMLOWP} -I${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTO} -I${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOTEXT} -I${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_PROTOBUF_HOST_INCUDE} -I/usr/local/include -c ${TARGET_SRC}.cc -o ${CK_ENV_LIB_TF_MAKEFILE_DIR_GEN_TOOLS}/${TARGET_SRC}.o

fi