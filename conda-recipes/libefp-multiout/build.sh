
#ALLOPTS="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -I${PREFIX}/include/c++/v1 ${OPTS}"  # yea
#ALLOPTS="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include ${OPTS}"  # nay
ALLOPTS="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS}"  # yea


if [ "$(uname)" == "Darwin" ]; then

    # link against conda MKL & GCC
    if [ "$blas_impl" = "mkl" ]; then
        LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt${SHLIB_EXT}"
    fi

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}${SHLIB_EXT}" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_OPENMP=OFF \
        -DENABLE_XHOST=OFF \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF \
        -DINSTALL_DEVEL_HEADERS=ON \
        -Dpybind11_DIR="${PREFIX}/share/cmake/pybind11" \
        -DLAPACK_LIBRARIES=${LAPACK_INTERJECT}

        # works
        #-DCMAKE_C_COMPILER=${CC} \
        #-DCMAKE_CXX_COMPILER=${CXX} \
        #-DCMAKE_C_FLAGS="${ISA}" \
        #-DCMAKE_CXX_FLAGS="${ISA}" \
fi

if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2018/bin/compilervars.sh intel64
    set -x

    # link against conda MKL & GCC
    if [ "$blas_impl" = "mkl" ]; then
        LAPACK_INTERJECT="${PREFIX}/lib/libmkl_rt.so"
    else
        LAPACK_INTERJECT="${PREFIX}/lib/libopenblas.so"
    fi
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=icc \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_C_FLAGS="${ALLOPTS}" \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DPYMOD_INSTALL_LIBDIR="${PYMOD_INSTALL_LIBDIR}" \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_LIBRARY="${PREFIX}/lib/lib${PY_ABBR}.so" \
        -DPYTHON_INCLUDE_DIR="${PREFIX}/include/${PY_ABBR}" \
        -DBUILD_SHARED_LIBS=ON \
        -DENABLE_OPENMP=OFF \
        -DENABLE_XHOST=OFF \
        -DENABLE_GENERIC=ON \
        -DFRAGLIB_UNDERSCORE_L=OFF \
        -DFRAGLIB_DEEP=OFF \
        -DINSTALL_DEVEL_HEADERS=ON \
        -Dpybind11_DIR="${PREFIX}/share/cmake/pybind11" \
        -DLAPACK_LIBRARIES=${LAPACK_INTERJECT}
fi

# build
cd build
make -j${CPU_COUNT}

# install
make install

# test
# pytest in conda testing stage


# NOTES
# -----
# Note: add -DCMAKE_C_FLAGS="-liomp5" for static link w/o mkl
# Note: gcc4.8.5 just fine; using 5.2 for consistency.
# Note: older static MKL
    # force static link to Intel mkl, except for openmp
    #MKLROOT=/theoryfs2/common/software/intel2016/compilers_and_libraries_2016.2.181/linux/mkl/lib/intel64
    #LAPACK_INTERJECT="${MKLROOT}/libmkl_lapack95_lp64.a;-Wl,--start-group;${MKLROOT}/libmkl_intel_lp64.a;${MKLROOT}/libmkl_sequential.a;${MKLROOT}/libmkl_core.a;-Wl,--end-group;-lpthread;-lm;-ldl"

    #LAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt.so;${PREFIX}/lib/libiomp5.so;-fno-openmp;-lpthread;-lm;-ldl"
    #LAPACK_INCLUDE_DIRS="${PREFIX}/include"
    ## link against older libc for generic linux
    #TLIBC=/home/psilocaluser/installs/glibc2.12
    #LIBC_INTERJECT="-L${TLIBC}/usr/lib64 ${TLIBC}/lib64/libpthread.so.0 ${TLIBC}/lib64/libc.so.6"
