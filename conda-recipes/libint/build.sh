MAX_AM_ERI=7

if [ "$(uname)" == "Darwin" ]; then

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER="${PREFIX}/bin/gcc" \
        -DCMAKE_CXX_COMPILER="${PREFIX}/bin/g++" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DMAX_AM_ERI=${MAX_AM_ERI} \
        -DBUILD_SHARED_LIBS=ON
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers and mkl
    source /theoryfs2/common/software/intel2016/bin/compilervars.sh intel64

    # link against older libc for generic linux
    TLIBC=/theoryfs2/ds/cdsgroup/psi4-compile/nightly/glibc2.12
    LIBC_INTERJECT="${TLIBC}/lib64/libc.so.6"

    # configure
    ${PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_INSTALL_LIBDIR=lib
        -DMAX_AM_ERI=${MAX_AM_ERI} \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DLIBC_INTERJECT="${LIBC_INTERJECT}"
fi

# build
cd build
make -j${CPU_COUNT}
#make VERBOSE=1

# install
make install

# test
# no independent tests


# <<<  Notes  >>>

# * Recipe won't build if conda path has double slash. Error:
#
#   CMake Error at cmake_install.cmake:31 (file):
#     file called with network path DESTINATION.  This does not make sense when
#     using DESTDIR.  Specify local absolute path or remove DESTDIR environment
#     variable.
#   
#     DESTINATION=
#   
#     //anaconda/envs/_build/bin

