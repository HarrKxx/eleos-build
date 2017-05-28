#!/usr/bin/env bash
#example: ./build-win.sh -e ../eleos/ -d ../eleos-daemons/v0.0.4/ -v 0.0.4

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

# copy Win64 daemons
cp ${daemonDir}/zcash-cli.exe ./
cp ${daemonDir}/zcashd.exe ./
cp ${daemonDir}/zcl-cli.exe ./
cp ${daemonDir}/zcld.exe ./
#cp ${daemonDir}/zen-cli.exe ./
#cp ${daemonDir}/zend.exe ./

# build .app
cd ../
electron-packager ./eleos eleos --app-version=${version} --arch=x64 --platform=win32 --icon=./eleos-build/zen.ico --overwrite
