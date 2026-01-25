//
//  SSiOSPlatform.m
//  SmallStep
//

#import "SSiOSPlatform.h"

#if TARGET_OS_IPHONE

@implementation SSiOSPlatform

+ (NSString *)iOSDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject ?: @"";
}

+ (BOOL)isAppExtension {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSDictionary *extensionInfo = [mainBundle objectForInfoDictionaryKey:@"NSExtension"];
    return extensionInfo != nil;
}

@end

#endif
