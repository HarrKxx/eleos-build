#!/usr/bin/env bash

# Set variables
version="0.0.5"

#-------------------------------------------------------------------------------------------
echo "Building windows binaries ..."
./build-win.sh -e ../eleos/ -d ../eleos-daemons/v${version}/ -v ${version}

#-------------------------------------------------------------------------------------------
echo "Building mac binaries ..."
#./build-mac.sh -e ../ -d ./v${version}/ -v ${version}

#-------------------------------------------------------------------------------------------
