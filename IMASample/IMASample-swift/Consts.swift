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
let kPrerollAdsResponse = "<VAST xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"vast.xsd\" version=\"3.0\">\n" +
    " <Ad id=\"697203496\">\n" +
    "  <InLine>\n" +
    "   <AdSystem>GDFP</AdSystem>\n" +
    "   <AdTitle>External NCA1C1L1 Linear Inline</AdTitle>\n" +
    "   <Description><![CDATA[External NCA1C1L1 Linear Inline ad]]></Description>\n" +
    "   <Error><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=videoplayfailed[ERRORCODE]]]></Error>\n" +
    "   <Impression><![CDATA[https://securepubads.g.doubleclick.net/pcs/view?xai=AKAOjssZdFAbuW5sMyDqkR4_GSUtti9tHDUIU2lm_uTGkJSlDiDkujBOLO0_BBfFit95NwL6w8MHDjXzh-fxnnY2ORSaX3W0ldWlvTj4RNhRyVd9D1g4DUPXqD4A7urmLuFcpp7JqgPAQfPnP5rQGZ7t9gS6mblSKVDg2qhddsOQCmWLFeBNSbWzt-Xpw3rKj15Vui6S_rhQf-iLx28hNPORnHMwG8QnQKq2XFBDV4BDCxWrBK1aeHS9yoUlBuQKKw&sig=Cg0ArKJSzOus2WfZA6-7EAE&adurl=]]></Impression>\n" +
    "   <Creatives>\n" +
    "    <Creative id=\"57859154776\" sequence=\"1\">\n" +
    "     <Linear>\n" +
    "      <Duration>00:00:10</Duration>\n" +
    "      <TrackingEvents>\n" +
    "       <Tracking event=\"start\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=part2viewed&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"firstQuartile\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=videoplaytime25&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"midpoint\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=videoplaytime50&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"thirdQuartile\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=videoplaytime75&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"complete\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=videoplaytime100&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"mute\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=admute&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"unmute\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=adunmute&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"rewind\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=adrewind&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"pause\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=adpause&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"resume\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=adresume&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"fullscreen\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=adfullscreen&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"creativeView\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=vast_creativeview&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"exitFullscreen\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=vast_exit_fullscreen&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"acceptInvitationLinear\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=acceptinvitation&ad_mt=[AD_MT]]]></Tracking>\n" +
    "       <Tracking event=\"closeLinear\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=adclose&ad_mt=[AD_MT]]]></Tracking>\n" +
    "      </TrackingEvents>\n" +
    "      <VideoClicks>\n" +
    "       <ClickThrough id=\"GDFP\"><![CDATA[https://pubads.g.doubleclick.net/pcs/click?xai=AKAOjsspWGBm8LTbrBCN4_mjE5LQtlF-NR1SvUkWrA6Ce5xcVW-1YBHtHBeFnMZdTonv-NeqBiWxGreBRUpnUfdhR3UhdDmFTFhLyVRc0Kralb0uDYq5GPG8tSfdIKQBw6RtHG2LiObXqeBPExXvXkGqpSb8hl9C56e5qo89eT8aE2mnYNLMiRujrSX1HSa1SOCk3bxbP8xheAHHcQ8izzJbK6GCSzcIQ93TRRqL3tqawrGXRKNQ1RrITMQ&sig=Cg0ArKJSzJ2UrpNRHZCb&adurl=https://developers.google.com/interactive-media-ads/docs/vastinspector_dual]]></ClickThrough>\n" +
    "      </VideoClicks>\n" +
    "      <MediaFiles>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"1280\" height=\"720\" type=\"video/mp4\" bitrate=\"450\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/15/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2Fmp4/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/1A07BA6BD5171BEA5893938B5365FE21581AD185.1E3E88A77939848972CB1679C3AE7A8B4E8857B3/key/ck2/file/file.mp4]]></MediaFile>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"176\" height=\"144\" type=\"video/3gpp\" bitrate=\"36\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/17/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2F3gpp/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/4635A605F191D0751864033125BCF9DB1BE1A6F3.3E847B7B0A4D9B6C43F42E5AEF4CF1FF0949F32F/key/ck2/file/file.3gp]]></MediaFile>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"320\" height=\"180\" type=\"video/3gpp\" bitrate=\"69\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/36/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2F3gpp/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/85EB78858E8F1BE7D3A871B121AB69AD4ECE53B4.0E263013C8F1EBA8ABC122E981054FB37F626F99/key/ck2/file/file.3gp]]></MediaFile>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"640\" height=\"360\" type=\"video/mp4\" bitrate=\"118\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/18/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2Fmp4/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/8CED9D0F6CFA93E72A31EBE12EC31FF4F7D0027A.A2533805ADF2796224A87FF6520CB09C39AD11C0/key/ck2/file/file.mp4]]></MediaFile>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"640\" height=\"360\" type=\"video/webm\" bitrate=\"119\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/43/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2Fwebm/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/303BCE001DC5834B852CA97AAB73A35F9066D2AF.999FAD64B5F05C13EAD87EF203352FDCF7421525/key/ck2/file/file.webm]]></MediaFile>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"1280\" height=\"720\" type=\"video/webm\" bitrate=\"229\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/45/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2Fwebm/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/14C66B9284984755128D5D81341D39D0135C6EEF.7542B6FD006C3728EFDC1E2BEE411F785AA0554D/key/ck2/file/file.webm]]></MediaFile>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"854\" height=\"480\" type=\"video/webm\" bitrate=\"132\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/44/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2Fwebm/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/B9BC6EEEFD7F235361496D1302BBEB1EA59BB17C.0D878F49C31A55D835811D33E89D6A9DA4B927D3/key/ck2/file/file.webm]]></MediaFile>\n" +
    "       <MediaFile id=\"GDFP\" delivery=\"progressive\" width=\"1280\" height=\"720\" type=\"video/mp4\" bitrate=\"241\" scalable=\"true\" maintainAspectRatio=\"true\"><![CDATA[https://redirector.gvt1.com/videoplayback/id/a33fc5b2685eb16e/itag/22/source/gfp_video_ads/requiressl/yes/acao/yes/mime/video%2Fmp4/ctier/L/ip/0.0.0.0/ipbits/0/expire/1562104170/sparams/ip,ipbits,expire,id,itag,source,requiressl,acao,mime,ctier/signature/5292A1963186033253827AFA97140E213B1F9EB1.7E61775799CB27221D17F5837A40772CB4A6FC3A/key/ck2/file/file.mp4]]></MediaFile>\n" +
    "      </MediaFiles>\n" +
    "     </Linear>\n" +
    "    </Creative>\n" +
    "    <Creative id=\"57857370976\" sequence=\"1\">\n" +
    "     <CompanionAds>\n" +
    "      <Companion id=\"57857370976\" width=\"300\" height=\"250\">\n" +
    "       <StaticResource creativeType=\"image/png\"><![CDATA[https://pagead2.googlesyndication.com/pagead/imgad?id=CICAgKDTwILFiwEQrAIY-gEyCAAnmA4d6uc2]]></StaticResource>\n" +
    "       <TrackingEvents>\n" +
    "        <Tracking event=\"creativeView\"><![CDATA[https://securepubads.g.doubleclick.net/pcs/view?xai=AKAOjsvfjv2v32HJd8zKy1PeaO2Z9c20EWtNnrMv3BXVH9ojGRTfgo7SQG6erff8Fg42QJFfv6WfNiYP-6a3nGq7b38nzpZxkyQ1bvtHa3HH9eGQFhIQWeyKSKwjEkVl6LpYuB-V3jlV3jhwCnYgC7i7e-3IlzQWpbQXT99TtSLPSPCeTwM_--hWsyPRAj0jcODlaweLaaF7AS82Cl7pV1aGtDzXySDq_jQ6jC7HPfuOW6Gf_Y1dvzv22x1qfiHaWw&sig=Cg0ArKJSzBwxiwdU1fJMEAE&adurl=]]></Tracking>\n" +
    "       </TrackingEvents>\n" +
    "       <CompanionClickThrough><![CDATA[https://pubads.g.doubleclick.net/pcs/click?xai=AKAOjstwkIn2XauSuGrQUh0OamyYPemUeb2OGghJjtTg4jm0tvtgjWSFhIlaQjlIHb1lMS-2DnvvDvwR2Dg6tQGYLDpuVH3r7-46Ybk60GD8ja2zrjB68vGZviCU3_qDQDFPJK_JEFnCQVCAdpn0cHUdnUTekO5KM17PtzTw_RmePqXR47Pz6hMOa6pKALtnGKelX2J0fg24BZ4HX9avPnSHD0Yefj70IU1ZERXTvjmtNCxTg-1OX0yUNKw&sig=Cg0ArKJSzJoCZc5S8qqE&adurl=https://developers.google.com/interactive-media-ads/docs/vastinspector_dual]]></CompanionClickThrough>\n" +
    "      </Companion>\n" +
    "     </CompanionAds>\n" +
    "    </Creative>\n" +
    "   </Creatives>\n" +
    "   <Extensions><Extension type=\"waterfall\" fallback_index=\"0\"/><Extension type=\"geo\"><Country>IL</Country><Bandwidth>4</Bandwidth><BandwidthKbps>20000</BandwidthKbps></Extension><Extension type=\"activeview\"><CustomTracking><Tracking event=\"viewable_impression\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=viewable_impression&acvw=[VIEWABILITY]&gv=[GOOGLE_VIEWABILITY]&ad_mt=[AD_MT]]]></Tracking><Tracking event=\"abandon\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=video_abandon&acvw=[VIEWABILITY]&gv=[GOOGLE_VIEWABILITY]]]></Tracking></CustomTracking><ActiveViewMetadata><![CDATA[ud=1&la=1&alp=xai&alh=3960329791&]]></ActiveViewMetadata></Extension><Extension type=\"metrics\"><FeEventId>CX0bXYLONcSB-gbV8rL4Cg</FeEventId><AdEventId>CIu4wIXLluMCFRcr4AodekIAUw</AdEventId></Extension><Extension type=\"ShowAdTracking\"><CustomTracking><Tracking event=\"show_ad\"><![CDATA[https://securepubads.g.doubleclick.net/pcs/view?xai=AKAOjsuGqNUJSwDU1mRwPb-wdNitQLvqw0v2Hyx-PmMlASnoqE2nD179fefdNe3l5qwbggy2tq71ojqXQjbDJR-LcGv6PDXy6o6vPI3PPiMXSSLaZOszf9iskxHuuM17yOvytaSVgqRmzZbAUfH7ArhLWIxt8s9w1SEGDHdjPNZqgJDCotl27mFAX99v0ttGdQz-pvHmbZcjeULZ0DKYWnhD1-NDbkKcWHscP70POJu-0H2z1k2x5HFkLXIWxqtzEdyo&sig=Cg0ArKJSzIS9srH1KuFPEAE&adurl=]]></Tracking></CustomTracking></Extension><Extension type=\"video_ad_loaded\"><CustomTracking><Tracking event=\"loaded\"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BAXsBCX0bXcuPNpfWgAf6hIGYBfDYj-sGAAAAEAEgqN27JjgAWNjGssXXAWD5qvSDnBC6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIlLzEyNDMxOTA5Ni9leHRlcm5hbC9zaW5nbGVfYWRfc2FtcGxlc_gChNIegAMBkAOEB5gDrAKoAwHgBAHSBQYQqPa5zAKQBgGgBiPYBwHgBwvSCAcIgGEQARgN&sigh=TqpjVGCe3Ac&label=video_ad_loaded]]></Tracking></CustomTracking></Extension></Extensions>\n" +
    "  </InLine>\n" +
    " </Ad>\n" +
"</VAST>\n"
