#!/bin/bash

# run within a docker quay.io/pypa/manylinux1_x86_64 instance

# get omniORB
sourceforge=http://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.2/omniORB-4.2.2.tar.bz2
wget $sourceforge -P /tmp/ --no-check-certificate
tar -xjvf /tmp/omniORB-4.2.2.tar.bz2 -C /tmp/

# get omniORBpy
sourceforge_py=http://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.2/omniORBpy-4.2.2.tar.bz2
wget $sourceforge_py -P /tmp/ --no-check-certificate
tar -xjvf /tmp/omniORBpy-4.2.2.tar.bz2 -C /tmp/

# main build path
tmp_path=/tmp/corba
mkdir $tmp_path

# build omniorb
cd /tmp/omniORB-4.2.2/
mkdir build
cd build
PYBIN='/opt/_internal/cpython-2.7.15-ucs4/bin/python'
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

for PYBINDIR in /opt/python/*/bin; do
    # echo $PYBINDIR

    # skip python 3.7
    if [[ $PYBINDIR =~ .*37.* ]]
    then
    	continue
    fi

    pyver="$(cut -d'/' -f4 <<<$PYBINDIR)"

    # clean out the build directory or omniorb will not be rebuilt
    cd /tmp/omniORBpy-4.2.2/
    mkdir build
    cd build
    ../configure --prefix=$omnipy_path --with-omniorb=$omni_path PYTHON=$PYBINDIR/python
    make
    make install
    cd ..
    rm -rf build

    bindir=/tmp/omniorbpy_bin/$pyver/
    mkdir $bindir
    rm -rf $omnipy_path/lib/*/site-packages/__pycache__
    mv $omnipy_path/lib/*/site-packages/_* $bindir
    rm -rf $omnipy_path

    cd /tmp/omniorbpy_bin
    tar xf base.tar
    cd base
    cp ../$pyver/*_omnipy* ansys_corba/
    cp $omni_path/lib/libomnithread.so.4 ansys_corba/
    cp $omni_path/lib/libomniORB4.so.2 ansys_corba/
    $PYBINDIR/python setup.py bdist_wheel -q
    mv dist/* ../wheels/ansys_corba-0.1.0-$pyver-manylinux1_x86_64.whl
    cd ..
    rm -rf base

done
