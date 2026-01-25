//
//  SSPlatform.m
//  SmallStep
//

#import "SSPlatform.h"

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
    #define SS_PLATFORM_MACOS 1
#elif TARGET_OS_IPHONE
    #define SS_PLATFORM_IOS 1
#elif defined(__GNUSTEP__) || defined(__linux__)
    #define SS_PLATFORM_LINUX 1
#endif

@implementation SSPlatform

+ (SSPlatformType)currentPlatform {
#if SS_PLATFORM_MACOS
    return SSPlatformTypemacOS;
#elif SS_PLATFORM_IOS
    return SSPlatformTypeiOS;
#elif SS_PLATFORM_LINUX
    return SSPlatformTypeLinux;
#else
    return SSPlatformTypeUnknown;
#endif
}

+ (BOOL)isMacOS {
    return [self currentPlatform] == SSPlatformTypemacOS;
}

+ (BOOL)isiOS {
    return [self currentPlatform] == SSPlatformTypeiOS;
}

+ (BOOL)isLinux {
    return [self currentPlatform] == SSPlatformTypeLinux;
}

+ (NSString *)platformName {
    switch ([self currentPlatform]) {
        case SSPlatformTypemacOS:
            return @"macOS";
        case SSPlatformTypeiOS:
            return @"iOS";
        case SSPlatformTypeLinux:
            return @"Linux";
        default:
            return @"Unknown";
    }
}

+ (NSString *)platformVersion {
#if SS_PLATFORM_MACOS || SS_PLATFORM_IOS
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    if ([processInfo respondsToSelector:@selector(operatingSystemVersionString)]) {
        return [processInfo operatingSystemVersionString];
    }
    return @"Unknown";
#elif SS_PLATFORM_LINUX
    // For Linux, we could read from /etc/os-release or similar
    return @"Linux (GNUStep)";
#else
    return @"Unknown";
#endif
}

@end
