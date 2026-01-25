//
//  SSMacOSPlatform.m
//  SmallStep
//

#import "SSMacOSPlatform.h"

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation SSMacOSPlatform

+ (NSString *)macOSApplicationSupportPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return paths.firstObject ?: @"";
}

+ (BOOL)isSandboxed {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    return [environment objectForKey:@"APP_SANDBOX_CONTAINER_ID"] != nil;
}

@end

#endif
