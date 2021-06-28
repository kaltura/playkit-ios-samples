//
//  VideoData.h
//  PhoenixAnalyticsSample
//
//  Created by Nilit Danan on 7/17/19.
//  Copyright © 2019 Kaltura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoData : NSObject
    
    @property (assign, nonatomic) NSInteger partnerID;
    @property (strong, nonatomic) NSString *serverURL;
    @property (strong, nonatomic) NSString *ks;
    @property (strong, nonatomic) NSString *assetId;
    @property (strong, nonatomic) NSString *networkProtocol;
    @property (strong, nonatomic) NSArray <NSString*> *formats;


    - (instancetype)initWithPartnerID:(NSInteger)partnerID serverURL:(NSString *)serverURL ks:(NSString *)ks assetId:(NSString *)assetId networkProtocol:(NSString *)networkProtocol formats:(NSArray <NSString*> *)formats ;
    
    @end
