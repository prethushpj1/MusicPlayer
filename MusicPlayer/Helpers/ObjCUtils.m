//
//  ObjCUtils.m
//  MusicPlayer
//
//  Created by Prethush on 19/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

#import "ObjCUtils.h"
#import <sys/utsname.h>

@implementation ObjCUtils
+ (BOOL)isIphoneX{
    static BOOL isiPhoneX = NO;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
        NSString *model = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
        struct utsname systemInfo;
        uname(&systemInfo);
        
        NSString *model = [NSString stringWithCString:systemInfo.machine
                                             encoding:NSUTF8StringEncoding];
#endif
        isiPhoneX = [model isEqualToString:@"iPhone10,3"] || [model isEqualToString:@"iPhone10,6"];
    });
    
    return isiPhoneX;
}
@end
