#import "Video.h"

@implementation Video
    
- (instancetype)initWithTitle:(NSString *)title
                    thumbnail:(UIImage *)thumbnail
                        video:(NSString *)video
                          tag:(NSString *)tag
                  adsResponse:(NSString *)adsResponse {
    self = [super init];
    if (self) {
        _title = [title copy];
        _thumbnail = [thumbnail copy];
        _video = [video copy];
        _tag = [tag copy];
        _adsResponse = [adsResponse copy];
    }
    return self;
}
    
@end
