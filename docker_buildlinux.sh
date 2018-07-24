#!/bin/bash

# start docker
docker run -d -i quay.io/pypa/manylinux1_x86_64 /bin/bash
CONTAINERID=$(docker ps -q -n 1)

# copy over base python source
cd ..
docker exec -it $CONTAINERID mkdir /tmp/omniorbpy_bin
docker exec -it $CONTAINERID mkdir /tmp/omniorbpy_bin/wheels
docker cp base.tar $CONTAINERID:/tmp/omniorbpy_bin

# build wheels
docker cp docker.sh $CONTAINERID:/tmp/
docker exec -it $CONTAINERID chmod +x /tmp/docker.sh
docker exec -it $CONTAINERID /tmp/docker.sh

# move generated wheels 
docker cp $CONTAINERID:/tmp/omniorbpy_bin/wheels /tmp/wheels
cp /tmp/wheels/* wheels/dist
