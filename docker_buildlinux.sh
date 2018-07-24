#!/bin/bash

# start docker
docker run -d -i quay.io/pypa/manylinux1_x86_64 /bin/bash
CONTAINERID=$(docker ps -q -n 1)

# copy over base python source
cd ..
tar -cf base.tar base/
docker exec -it $CONTAINERID mkdir /tmp/omniorbpy_bin
docker exec -it $CONTAINERID mkdir /tmp/omniorbpy_bin/wheels
docker cp base.tar $CONTAINERID:/tmp/omniorbpy_bin

# build wheels
docker cp base/docker.sh $CONTAINERID:/tmp/
docker exec -it $CONTAINERID chmod +x /tmp/docker.sh
docker exec -it $CONTAINERID /tmp/docker.sh

# move generated wheels
# mkdir /tmp/wheels
docker cp $CONTAINERID:/tmp/omniorbpy_bin/wheels /tmp/
mv /tmp/wheels/* dist/
rm -rf /tmp/wheels
