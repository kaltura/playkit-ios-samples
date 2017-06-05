#!/usr/bin/env bash

#ARGUMENTS
BRANCH=$1

./build_sample.sh $BRANCH BasicSample BasicSample BasicSample-Swift
./build_sample.sh $BRANCH ChangeMediaSample ChangeMediaSample ChangeMediaSample-Swift
./build_sample.sh $BRANCH ControlVideoWithSpeechRecognition BasicSample
./build_sample.sh $BRANCH EventsRegistration EventsRegistration EventsRegistration-Swift
./build_sample.sh $BRANCH IMAPluginSample BasicSample
./build_sample.sh $BRANCH KalturaLiveStatsSample KalturaLiveStatsSample KalturaLiveStatsSample-Swift
./build_sample.sh $BRANCH KalturaStatsSample KalturaStatsSample KalturaStatsSample-Swift
./build_sample.sh $BRANCH OVPMediaProviderSample OVPMediaProviderSample OVPMediaProviderSample-Swift
./build_sample.sh $BRANCH PhoenixAnalyticsSample PhoenixAnalyticsSample PhoenixAnalyticsSample-Swift
./build_sample.sh $BRANCH PlayKitAppleTVSample PlayKitAppleTVSample
./build_sample.sh $BRANCH TracksSample BasicSample
./build_sample.sh $BRANCH YouboraSample YouboraSample YouboraSample-Swift
./build_sample.sh $BRANCH TVPAPIAnalyticsSample TVPAPIAnalyticsSample TVPAPIAnalyticsSample-Swift



