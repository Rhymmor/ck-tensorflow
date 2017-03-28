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

export NDK_ROOT=${CK_ANDROID_NDK_ROOT_DIR}

################################################################################################
# TODO: remove to libjpeg package

LIBJPEG_DIR=obj/local/${CK_ANDROID_ABI}/libjpeg.a

if [ ! -f "${CK_LIB_LIBJPEG_TENSORFLOW}/${LIBJPEG_DIR}" ]; then
    cd ${CK_LIB_LIBJPEG_TENSORFLOW} && ${NDK_ROOT}/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk APP_ABI=${CK_ANDROID_ABI} ${LIBJPEG_DIR}
    if [ "${?}" != "0" ] ; then
        echo ""
        echo "Error: Compiling static library for libjpeg failed!"
        exit 1
    fi
fi

################################################################################################

cd ${INSTALL_DIR}/src
MAKEFILE_DIR=tensorflow/contrib/makefile

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
    tensorflow/contrib/makefile/compile_android_protobuf.sh -c -a ${CK_ANDROID_ABI}
    if [ "${?}" != "0" ] ; then
        echo ""
        echo "Error: Compiling android protobuf for '${CK_ENV_LIB_TF}/src/${MAKEFILE_DIR}' failed!"
        exit 1
    fi
fi

################################################################################################

if [[ "${CK_ANDROID_ABI}" == "arm64-v8a" ]]; then
    TOOLCHAIN=aarch64-linux-android-4.9
    SYSROOT_ARCH=arm64
    BIN_PREFIX=aarch64-linux-android
elif [[ "${CK_ANDROID_ABI}" == "armeabi-v7a" ]]; then
    TOOLCHAIN=arm-linux-androideabi-4.9
    SYSROOT_ARCH=arm
    BIN_PREFIX=arm-linux-androideabi
fi

ABS_MAKEFILE_DIR=${INSTALL_DIR}/src/${MAKEFILE_DIR}
GENDIR=${ABS_MAKEFILE_DIR}/gen
PROTOGENDIR=${GENDIR}/proto
PBTGENDIR=${GENDIR}/proto_text

if [[ "$OSTYPE" == "darwin"* ]]; then
  OS_PATH=darwin
else
  OS_PATH=linux
fi

CXX="${CC_PREFIX} ${NDK_ROOT}/toolchains/${TOOLCHAIN}/prebuilt/${OS_PATH}-x86_64/bin/${BIN_PREFIX}-g++"

OPTFLAGS="-O2"
CXXFLAGS="--std=c++11 -DIS_SLIM_BUILD -fno-exceptions -DNDEBUG ${OPTFLAGS}"
CXXFLAGS="${CXXFLAGS} --sysroot ${NDK_ROOT}/platforms/android-21/arch-${SYSROOT_ARCH} -Wno-narrowing -fPIE"

if [[ "${CK_ANDROID_ABI}" == "armeabi-v7a" ]]; then
    CXXFLAGS="${CXXFLAGS} -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
fi

INCLUDES="-I${NDK_ROOT}/sources/android/support/include -I${NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/4.9/include -I${NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/4.9/libs/${CK_ANDROID_ABI}/include"
INCLUDES="${INCLUDES} -I. -I${ABS_MAKEFILE_DIR}/downloads/ -I${ABS_MAKEFILE_DIR}/downloads/eigen -I${ABS_MAKEFILE_DIR}/downloads/gemmlowp"
INCLUDES="${INCLUDES} -I${ABS_MAKEFILE_DIR}/gen/protobuf/include -I${PROTOGENDIR} -I${PBTGENDIR}"
INCLUDES="${INCLUDES} -I${CK_LIB_LIBJPEG_TENSORFLOW} -I${CK_ENV_LIB_RTL_XOPENME_INCLUDE}"

LIBS="-L${CK_ENV_LIB_RTL_XOPENME_LIB} -lrtlxopenme -L${CK_LIB_LIBJPEG_TENSORFLOW}/obj/local/${CK_ANDROID_ABI} -ljpeg "
LIBS="${LIBS} -lgnustl_static -lprotobuf -llog -lz -lm"

LD="${NDK_ROOT}/toolchains/${TOOLCHAIN}/prebuilt/${OS_PATH}-x86_64/${BIN_PREFIX}/bin/ld"

LDFLAGS="-L${ABS_MAKEFILE_DIR}/gen/protobuf/lib -L${NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/4.9/libs/${CK_ANDROID_ABI} -fPIE -pie -v"

if [[ "${CK_ANDROID_ABI}" == "armeabi-v7a" ]]; then
    LDFLAGS="${LDFLAGS} -march=armv7-a"
fi

AR=${NDK_ROOT}/toolchains/${TOOLCHAIN}/prebuilt/${OS_PATH}-x86_64/bin/${BIN_PREFIX}-ar

make -f ${MAKEFILE_DIR}/Makefile TARGET=ANDROID CXX="${CXX}" CXXFLAGS="${CXXFLAGS}" INCLUDES="${INCLUDES}" LIBS="${LIBS}" LD="${LD}" LDFLAGS="${LDFLAGS}"

if [ "${?}" != "0" ] ; then
  echo "Error: make failed!"
  exit 1
fi

return 0
