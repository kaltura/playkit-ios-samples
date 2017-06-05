#!/usr/bin/env bash

#ARGUMENTS
BRANCH=$1
FOLDER_NAME=$2
WORKSPACE_NAME=$3
SECOND_TARGET_NAME=$4

echo arguments: $*

echo cd to $FOLDER_NAME
cd $FOLDER_NAME

PK_BRANCH=$BRANCH pod update

echo -e "\nbuild target for $FOLDER_NAME\n"
xcodebuild -scheme $FOLDER_NAME -workspace $WORKSPACE_NAME.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 7' | tee xcodebuild.log | xcpretty

if [ $SECOND_TARGET_NAME != "" ]; then
    echo -e "\nbuild swift target for $SECOND_TARGET_NAME\n"
    xcodebuild -scheme $SECOND_TARGET_NAME -workspace $WORKSPACE_NAME.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 7' | tee xcodebuild.log | xcpretty
fi