#!/usr/bin/env bash

set -e

#ARGUMENTS
BRANCH=$1
exit_names=()

if ./build_sample.sh $BRANCH BasicSample BasicSample BasicSample-Swift; then
    exit_names+=("BasicSample")
fi
if ./build_sample.sh $BRANCH ChangeMediaSample ChangeMediaSample ChangeMediaSample-Swift; then
    exit_names+=("ChangeMediaSample")
fi
if ./build_sample.sh $BRANCH ControlVideoWithSpeechRecognition BasicSample; then
    exit_names+=("ControlVideoWithSpeechRecognition")
fi
if ./build_sample.sh $BRANCH EventsRegistration EventsRegistration EventsRegistration-Swift; then
    exit_names+=("EventsRegistration")
fi
if ./build_sample.sh $BRANCH IMAPluginSample BasicSample; then
    exit_names+=("IMAPluginSample")
fi
if ./build_sample.sh $BRANCH KalturaLiveStatsSample KalturaLiveStatsSample KalturaLiveStatsSample-Swift; then
    exit_names+=("KalturaLiveStatsSample")
fi
if ./build_sample.sh $BRANCH KalturaStatsSample KalturaStatsSample KalturaStatsSample-Swift; then
    exit_names+=("KalturaStatsSample")
fi
if ./build_sample.sh $BRANCH OVPMediaProviderSample OVPMediaProviderSample OVPMediaProviderSample-Swift; then
    exit_names+=("OVPMediaProviderSample")
fi
if ./build_sample.sh $BRANCH PhoenixAnalyticsSample PhoenixAnalyticsSample PhoenixAnalyticsSample-Swift; then
    exit_names+=("PhoenixAnalyticsSample")
fi
if ./build_sample.sh $BRANCH PlayKitAppleTVSample PlayKitAppleTVSample; then
    exit_names+=("PlayKitAppleTVSample")
fi
if ./build_sample.sh $BRANCH TracksSample BasicSample; then
    exit_names+=("TracksSample")
fi
if ./build_sample.sh $BRANCH YouboraSample YouboraSample YouboraSample-Swift; then
    exit_names+=("YouboraSample")
fi
if ./build_sample.sh $BRANCH TVPAPIAnalyticsSample TVPAPIAnalyticsSample TVPAPIAnalyticsSample-Swift; then
    exit_names+=("TVPAPIAnalyticsSample")
fi

if [ $exit_names ]; then
    echo -e "\nThe projects that failed: ${exit_names[@]}\n"
    exit 1
fi






