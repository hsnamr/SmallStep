//
//  SSLinuxPlatform.m
//  SmallStep
//

#import "SSLinuxPlatform.h"
#import "../../Core/SSPlatform.h"

#if defined(__GNUSTEP__) || defined(__linux__)

@implementation SSLinuxPlatform

+ (NSString *)xdgDataHome {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *xdgDataHome = [environment objectForKey:@"XDG_DATA_HOME"];
    if (xdgDataHome && [xdgDataHome length] > 0) {
        return xdgDataHome;
    }
    NSString *homeDir = NSHomeDirectory();
    NSString *localDir = [homeDir stringByAppendingPathComponent:@".local"];
    return [localDir stringByAppendingPathComponent:@"share"];
}

+ (NSString *)xdgConfigHome {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *xdgConfigHome = [environment objectForKey:@"XDG_CONFIG_HOME"];
    if (xdgConfigHome && [xdgConfigHome length] > 0) {
        return xdgConfigHome;
    }
    return [NSHomeDirectory() stringByAppendingPathComponent:@".config"];
}

+ (NSString *)xdgCacheHome {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *xdgCacheHome = [environment objectForKey:@"XDG_CACHE_HOME"];
    if (xdgCacheHome && [xdgCacheHome length] > 0) {
        return xdgCacheHome;
    }
    return [NSHomeDirectory() stringByAppendingPathComponent:@".cache"];
}

@end

#endif
