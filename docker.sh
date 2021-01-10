#!/bin/bash

# run within a docker quay.io/pypa/manylinux1_x86_64 instance

# get omniORB
OMNI_VERSION=4.2.4
OMNI_PATH=/tmp/omni
tar -xjvf $OMNI_PATH/omniORBpy-$OMNI_VERSION.tar.bz2 -C /tmp/
tar -xjvf $OMNI_PATH/omniORB-$OMNI_VERSION.tar.bz2 -C /tmp/

# main build path
tmp_path=/tmp/corba
mkdir $tmp_path

# build omniorb
cd /tmp/omniORB-$OMNI_VERSION/
mkdir build
cd build
PYBIN=/opt/python/cp37-cp37m/bin/python

omni_path=$tmp_path/omni
../configure --prefix=$omni_path PYTHON=$PYBIN
make
make install

# build omniorbpy
omnipy_path=$tmp_path/omnipy

# /opt/python/cp27-cp27m/bin
# /opt/python/cp27-cp27mu/bin
# /opt/python/cp34-cp34m/bin
# /opt/python/cp35-cp35m/bin
# /opt/python/cp36-cp36m/bin
# /opt/python/cp37-cp37m/bin
# /opt/python/cp38-cp38m/bin

mkdir -p $OMNI_PATH/wheels

BUILT_OMNI_PY=/tmp/omniorbpy_bin
mkdir -p $BUILT_OMNI_PY
cp $OMNI_PATH/base.tar $BUILT_OMNI_PY

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$omni_path/lib

for PYBINDIR in /opt/python/*/bin; do
    # echo $PYBINDIR

    # skip 2.7
    if [[ $PYBINDIR == .*27.* ]]
    then
    	continue
    elif [[ $PYBINDIR == .*27.* ]]
    then
        continue
    fi

    pyver="$(cut -d'/' -f4 <<<$PYBINDIR)"

    # clean out the build directory or omniorb will not be rebuilt
    cd /tmp/omniORBpy-$OMNI_VERSION/
    mkdir -p build && cd build
    ../configure --prefix=$omnipy_path --with-omniorb=$omni_path PYTHON=$PYBINDIR/python
    make && make install
    cd ..
    rm -rf build

    bindir=$BUILT_OMNI_PY/$pyver/
    mkdir -p $bindir
    rm -rf $omnipy_path/lib/*/site-packages/__pycache__
    mv $omnipy_path/lib/*/site-packages/_* $bindir
    rm -rf $omnipy_path

    cd $BUILT_OMNI_PY
    tar xf base.tar
    cd base
    cp ../$pyver/*_omnipy* ansys_corba/
    # cp $omni_path/lib/libomnithread.so.4 ansys_corba/
    # cp $omni_path/lib/libomniORB4.so.2 ansys_corba/
    $PYBINDIR/python setup.py bdist_wheel -q
    auditwheel repair dist/ansys_corba*
    WHL_NAME=ansys_corba-0.1.1-$pyver-manylinux2010_x86_64.whl
    mv wheelhouse/*manylinux2010*.whl $OMNI_PATH/wheels/$WHL_NAME
    cd ..
    rm -rf base

done
