#!/usr/bin/env bash

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

# copy Win64 daemons
cp ${daemonDir}/zcash-cli.exe ./
cp ${daemonDir}/zcashd.exe ./
cp ${daemonDir}/zcl-cli.exe ./
cp ${daemonDir}/zcld.exe ./
cp ${daemonDir}/zen-cli.exe ./
cp ${daemonDir}/zend.exe ./


# build .app
electron-packager ${scriptDir}/../eleos eleos --out=${scriptDir} --app-version=${version} --arch=x64 --platform=win32 --icon=${scriptDir}/zen.ico --overwrite

# build installer
#cd ${scriptDir}
#echo ${scriptDir}
electron-installer-windows --src ${scriptDir}/eleos-win32-x64/ --dest ${scriptDir}

#rm -r -f ./eleos-win32-x64

#zip -r eleos-win32-x64-v${version}.zip ./eleos-win32-x64



