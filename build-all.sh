#!/usr/bin/env bash

# Set variables
version="0.0.9"

echo "-------------------------------------------------------------------------------------------"
echo "Building windows binaries ..."
./build-win.sh -e ../eleos/ -d ../eleos-daemons/v${version} -v ${version}

echo "-------------------------------------------------------------------------------------------"
echo "Building mac binaries ..."
#./build-mac.sh -e ../eleos/ -d ../eleos-daemons/v${version} -v ${version}

echo "-------------------------------------------------------------------------------------------"
echo "Building unix binaries ..."
#./build-unix.sh -e ../eleos/ -d ../eleos-daemons/v${version} -v ${version}
