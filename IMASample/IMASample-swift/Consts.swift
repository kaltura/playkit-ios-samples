//
//  Consts.swift
//  IMASample-swift
//
//  Created by Vadik on 07/11/2017.
//  Copyright © 2017 kaltura. All rights reserved.
//

import Foundation

// Standard pre-roll
let kPrerollTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="

// Skippable
let kSkippableTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="

// Post-roll
let kPostrollTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&correlator="

// Ad rues
let kAdRulesTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator="

// Ad rules pods
let kAdRulesPodsTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="

// VMAP pods
let kVMAPPodsTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="

// Wrapper
let kWrapperTag = "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dredirectlinear&correlator="

let kAdSenseTag = "http://googleads.g.doubleclick.net/pagead/ads?client=ca-video-afvtest&ad_type=video"

// Pre-roll as an adsResponse
let kPrerollAdsResponse =
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
