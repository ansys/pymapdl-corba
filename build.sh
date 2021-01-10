#!/bin/bash


docker run --rm -v `pwd`:/io quay.io/pypa/manylinux2010_x86_64 /io/.ci/build_wheels.sh $(python.version)
