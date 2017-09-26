#!/usr/bin/env bash

set -e

#ARGUMENTS
BRANCH=$1
exit_names=()

if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" BasicSample BasicSample BasicSample-Swift; then
    exit_names+=("BasicSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" ChangeMediaSample ChangeMediaSample ChangeMediaSample-Swift; then
    exit_names+=("ChangeMediaSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" ControlVideoWithSpeechRecognition BasicSample; then
    exit_names+=("ControlVideoWithSpeechRecognition")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" EventsRegistration EventsRegistration EventsRegistration-Swift; then
    exit_names+=("EventsRegistration")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" IMAPluginSample BasicSample; then
    exit_names+=("IMAPluginSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" KalturaLiveStatsSample KalturaLiveStatsSample KalturaLiveStatsSample-Swift; then
    exit_names+=("KalturaLiveStatsSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" KalturaStatsSample KalturaStatsSample KalturaStatsSample-Swift; then
    exit_names+=("KalturaStatsSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" OVPMediaProviderSample OVPMediaProviderSample OVPMediaProviderSample-Swift; then
    exit_names+=("OVPMediaProviderSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" PhoenixAnalyticsSample PhoenixAnalyticsSample PhoenixAnalyticsSample-Swift; then
    exit_names+=("PhoenixAnalyticsSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" TracksSample BasicSample; then
    exit_names+=("TracksSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" YouboraSample YouboraSample YouboraSample-Swift; then
    exit_names+=("YouboraSample")
fi
if ! ./build_sample.sh $BRANCH "iOS Simulator" "iPhone 7" TVPAPIAnalyticsSample TVPAPIAnalyticsSample TVPAPIAnalyticsSample-Swift; then
    exit_names+=("TVPAPIAnalyticsSample")
fi

# tvos simulator
if ! ./build_sample.sh $BRANCH "tvOS Simulator" "Apple TV 1080p" PlayKitAppleTVSample PlayKitAppleTVSample; then
    exit_names+=("PlayKitAppleTVSample")
fi

# if any of the build sample commands failed exit with failure and print failed projects.
if [ $exit_names ]; then
    echo -e "\nThe projects that failed: ${exit_names[@]}\n"
    exit 1
fi






