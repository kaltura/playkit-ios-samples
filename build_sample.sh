#!/usr/bin/env bash

#exit on failure and pipeline used to receive the exit code from xcpretty
set -eo pipefail

#ARGUMENTS
BRANCH=$1
PLATFORM=$2
DEVICE_NAME=$3
FOLDER_NAME=$4
WORKSPACE_NAME=$5
SECOND_TARGET_NAME=$6

echo arguments: $*

echo cd to $FOLDER_NAME
cd $FOLDER_NAME

PK_BRANCH=$BRANCH pod update

echo -e "\nbuild target for $FOLDER_NAME\n"
xcodebuild -scheme $WORKSPACE_NAME -workspace $WORKSPACE_NAME.xcworkspace -destination "platform=$PLATFORM,name=$DEVICE_NAME" | tee xcodebuild.log | xcpretty

if [ $SECOND_TARGET_NAME != "" ]; then
    echo -e "\nbuild swift target for $SECOND_TARGET_NAME\n"
    xcodebuild -scheme $SECOND_TARGET_NAME -workspace $WORKSPACE_NAME.xcworkspace -destination "platform=$PLATFORM,name=$DEVICE_NAME" | tee xcodebuild.log | xcpretty
fi