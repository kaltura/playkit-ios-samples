import Foundation

// DFP content path
let kDFPContentPath = "http://rmcdn.2mdn.net/Demo/html5/output.mp4";

// Android content path
let kAndroidContentPath = "https://s0.2mdn.net/instream/videoplayer/media/android.mp4";

// Big buck bunny content path
let kBigBuckBunnyContentPath = "http://googleimadev-vh.akamaihd.net/i/big_buck_bunny/" +
    "bbb-,480p,720p,1080p,.mov.csmil/master.m3u8";

// Bip bop content path
let kBipBopContentPath = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";

let baseTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/"

let kPrerollTag =     baseTag + "single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator=";
let kSkippableTag =   baseTag + "single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator=";
let kWrapperTag =     baseTag + "single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dredirectlinear&correlator=";
let kPostrollTag =    baseTag +   "ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&correlator=";
let kAdRulesTag =     baseTag +   "ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator=";
let kAdRulesPodsTag = baseTag +   "ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator=";
let kVMAPPodsTag =    baseTag +   "ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator=";
let kAdSenseTag =    "http://googleads.g.doubleclick.net/pagead/ads?client=ca-video-afvtest&ad_type=video";
