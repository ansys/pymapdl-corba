#!/bin/bash

# download
OMNI_VERSION=4.2.4
OMNI_PATH=/tmp/omni
mkdir -p $OMNI_PATH
sourceforge=http://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-$OMNI_VERSION/omniORB-$OMNI_VERSION.tar.bz2
wget $sourceforge -P $OMNI_PATH --no-check-certificate

# get omniORBpy
sourceforge_py=http://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-$OMNI_VERSION/omniORBpy-$OMNI_VERSION.tar.bz2
wget $sourceforge_py -P $OMNI_PATH --no-check-certificate


# start docker
docker run -v $OMNI_PATH:/tmp/omni -d -i quay.io/pypa/manylinux2010_x86_64 /bin/bash
CONTAINERID=$(docker ps -q -n 1)

# docker run -it -v $OMNI_PATH:/tmp/omni -i quay.io/pypa/manylinux2010_x86_64 /bin/bash

# copy over base python source
tar -cf $OMNI_PATH/base.tar *

# build wheels
docker cp docker.sh $CONTAINERID:/tmp/
docker exec -it $CONTAINERID chmod +x /tmp/docker.sh
docker exec -it $CONTAINERID /tmp/docker.sh

# wheels are now at:
ls $OMNI_PATH/wheels
