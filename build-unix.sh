#!/bin/bash

set -e

daemonDir=''
eleosDir=''
version=''

scriptDir=`pwd`

while getopts 'd:e:v:' flag; do
  case "${flag}" in
    d) daemonDir="${OPTARG}" ;;
    e) eleosDir="${OPTARG}" ;;
    v) version="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

# prep npm package
cd ${eleosDir}
npm install
$(npm bin)/electron-rebuild

# clean up eleos directory
rm -f eleos.htpasswd
rm -f *exe zcld* zcl-*
rm -f *exe zcashd* zcash-*
rm -f *exe zend* zen-*

# copy unix daemons
#cp ${daemonDir}/zcash-cli ./
#cp ${daemonDir}/zcashd ./
#cp ${daemonDir}/zcl-cli ./
#cp ${daemonDir}/zcld ./
#cp ${daemonDir}/zen-cli ./
#cp ${daemonDir}/zend ./

cd ${scriptDir}

# build .app
electron-packager ./../eleos eleos --platform linux --arch x64 --app-version=${version} --icon=${scriptDir}/zen.icns --overwrite

## build installer
electron-installer-debian --src ./eleos-linux-x64/ \
                          --dest ./ \
                          --arch amd64 \
                          --icon=${scriptDir}/zen.icns \
                          --overwrite




