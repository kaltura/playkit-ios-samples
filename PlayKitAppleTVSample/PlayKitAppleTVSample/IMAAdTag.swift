//
//  IMAAdTag.swift
//  PlayKitAppleTVSample
//
//  Created by Nilit Danan on 3/1/20.
//  Copyright © 2020 Kaltura. All rights reserved.
//

import Foundation

enum IMAAdTag: String, CustomStringConvertible {
    case Preroll = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
    // Skippable not working on tvOS!
    case Skippable = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
    case Postroll = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&correlator="
    case AdRules = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator="
    case AdRulesPods = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="
    case VMAPPods = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="
    case Wrapper = "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dredirectlinear&correlator="
    case AdSense = "http://googleads.g.doubleclick.net/pagead/ads?client=ca-video-afvtest&ad_type=video"
    case PrerollAdsResponse =
    """
    <VAST xsi:noNamespaceSchemaLocation="vast.xsd" version="3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <script/>
    <Ad id="697203496">
    <InLine>
    <AdTitle>External NCA1C1L1 Linear Inline</AdTitle>
    <Description><![CDATA[External NCA1C1L1 Linear Inline ad]]></Description>
    <Creatives>
    <Creative id="57859154776" sequence="1">
    <Linear>
    <Duration>00:00:5</Duration>
    <MediaFiles>
    <MediaFile id="GDFP" delivery="progressive" width="1280" height="720" type="video/mp4" bitrate="450" scalable="true" maintainAspectRatio="true"><![CDATA[http://techslides.com/demos/sample-videos/small.mp4]]></MediaFile>
    </MediaFiles>
    </Linear>
    </Creative>
    </Creatives>
    </InLine>
    </Ad>
    <script/>
    </VAST>
    """
    
    var description: String {
        switch self {
        case .Preroll:
            return "Preroll Tag"
        case .Skippable:
            return "Skippable Tag"
        case .Postroll:
            return "Postroll Tag"
        case .AdRules:
            return "AdRules Tag"
        case .AdRulesPods:
            return "AdRulesPods Tag"
        case .VMAPPods:
            return "VMAPPods Tag"
        case .Wrapper:
            return "Wrapper Tag"
        case .AdSense:
            return "AdSense Tag"
        case .PrerollAdsResponse:
            return "PrerollAdsResponse"
        }
    }
}

