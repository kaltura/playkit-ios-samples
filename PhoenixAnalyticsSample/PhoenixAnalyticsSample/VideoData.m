//
//  VideoData.m
//  PhoenixAnalyticsSample
//
//  Created by Nilit Danan on 7/17/19.
//  Copyright © 2019 Kaltura. All rights reserved.
//

#import "VideoData.h"

@implementation VideoData

    - (instancetype)initWithPartnerID:(NSInteger)partnerID serverURL:(NSString *)serverURL ks:(NSString *)ks assetId:(NSString *)assetId formats:(NSArray <NSString*> *)formats {
        self = [super init];
        if (self) {
            [self setPartnerID:partnerID];
            [self setServerURL:serverURL];
            [self setKs:ks];
            [self setAssetId:assetId];
            [self setFormats:formats];
        }
        return self;
    }

@end
