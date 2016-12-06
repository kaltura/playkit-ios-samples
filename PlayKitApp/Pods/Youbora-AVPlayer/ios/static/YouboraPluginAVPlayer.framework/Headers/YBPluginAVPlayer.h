//
//  YBPluginAVPlayer.h
//  YouboraPluginAVPlayer
//
//  Created by Joan on 18/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//
#import <TargetConditionals.h>

#if TARGET_OS_TV==1
@import YouboraLibTvOS;
#else
@import YouboraLib;
#endif

@interface YBPluginAVPlayer : YBPluginGeneric

@end
