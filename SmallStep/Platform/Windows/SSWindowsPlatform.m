//
//  SSWindowsPlatform.m
//  SmallStep
//

#import "SSWindowsPlatform.h"
#import "SSPlatform.h"

#if defined(WINOBJC) || defined(_WIN32)

@implementation SSWindowsPlatform

+ (NSString *)windowsDocumentsPath {
    // Try using NSSearchPathForDirectoriesInDomains if available in WinObjC
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count > 0) {
        return paths.firstObject;
    }
    
    // Fallback to user profile Documents
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    NSString *userProfile = [env objectForKey:@"USERPROFILE"];
    if (userProfile) {
        return [userProfile stringByAppendingPathComponent:@"Documents"];
    }
    return NSHomeDirectory();
}

+ (NSString *)windowsLocalAppDataPath {
    // Try using NSSearchPathForDirectoriesInDomains if available in WinObjC
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths.count > 0) {
        return paths.firstObject;
    }
    
    // Fallback to user profile AppData\Local
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    NSString *userProfile = [env objectForKey:@"USERPROFILE"];
    if (userProfile) {
        return [[userProfile stringByAppendingPathComponent:@"AppData"] stringByAppendingPathComponent:@"Local"];
    }
    NSString *localAppData = [env objectForKey:@"LOCALAPPDATA"];
    if (localAppData) {
        return localAppData;
    }
    return NSHomeDirectory();
}

+ (NSString *)windowsAppDataPath {
    // Fallback to user profile AppData\Roaming
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    NSString *userProfile = [env objectForKey:@"USERPROFILE"];
    if (userProfile) {
        return [[userProfile stringByAppendingPathComponent:@"AppData"] stringByAppendingPathComponent:@"Roaming"];
    }
    NSString *appData = [env objectForKey:@"APPDATA"];
    if (appData) {
        return appData;
    }
    return NSHomeDirectory();
}

+ (NSString *)windowsTempPath {
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    NSString *temp = [env objectForKey:@"TEMP"];
    if (!temp) {
        temp = [env objectForKey:@"TMP"];
    }
    if (temp) {
        return temp;
    }
    return NSTemporaryDirectory();
}

@end

#endif
