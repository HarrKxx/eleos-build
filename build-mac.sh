#!/bin/bash
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
rm -f *exe zend* zen-*

# copy MacOS daemons
cp ${daemonDir}/zcash-cli ./
cp ${daemonDir}/zcashd-mac ./
cp ${daemonDir}/zcl-cli ./
cp ${daemonDir}/zcld-mac ./
cp ${daemonDir}/zen-cli ./
cp ${daemonDir}/zend-mac ./

# build .app
cd ../
#electron-packager ./eleos eleos --app-version=${version} --icon=${scriptDir}/zen.icns --overwrite --osx-sign="Joshua Yabut (WWCFLJ762K)"
electron-packager ./eleos eleos --app-version=${version} --icon=${scriptDir}/zen.icns --overwrite

# fix dylibs
dylibbundler -od -b -x ./eleos-darwin-x64/eleos.app/Contents/Resources/app/zcashd-mac -x ./eleos-darwin-x64/eleos.app/Contents/Resources/app/zcash-cli -x ./eleos-darwin-x64/eleos.app/Contents/Resources/app/zcld-mac -x ./eleos-darwin-x64/eleos.app/Contents/Resources/app/zcl-cli -d ./eleos-darwin-x64/eleos.app/Contents/libs/ -p @executable_path/../../libs/

# codesign executables
cd ./eleos-darwin-x64/eleos.app/Contents/Resources/app/
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" zcld-mac
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" zcl-cli
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" zcashd-mac
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" zcash-cli
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" zend-mac
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" zen-cli
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" ../../libs/libgcc_s.1.dylib
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" ../../libs/libgomp.1.dylib
#codesign --force --sign "Developer ID Application: Joshua Yabut (WWCFLJ762K)" ../../libs/libstdc++.6.dylib

# codesign app
cd ${scriptDir}/../
#codesign --force --deep --sign "Joshua Yabut (WWCFLJ762K)" eleos-darwin-x64/eleos.app/

# build .dmg and codesign
electron-installer-dmg ${scriptDir}/../eleos-darwin-x64/eleos.app/ eleos-macos-v${version} --background=${scriptDir}/eleos_bg.png --overwrite
#codesign --force --sign "Joshua Yabut (WWCFLJ762K)" eleos-macos-v${version}.dmg
