//
//  SSFileSystem.m
//  SmallStep
//

#import "SSFileSystem.h"
#import "SSPlatform.h"

#if defined(WINOBJC) || defined(_WIN32)
#import "SSWindowsPlatform.h"
#endif

@implementation SSFileSystem

+ (instancetype)sharedFileSystem {
    static SSFileSystem *sharedFileSystem = nil;
    if (sharedFileSystem == nil) {
        sharedFileSystem = [[self alloc] init];
    }
    return sharedFileSystem;
}

- (NSString *)documentsDirectory {
#if SS_PLATFORM_MACOS || SS_PLATFORM_IOS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
#elif SS_PLATFORM_LINUX
    // On Linux, use ~/Documents or create it
    NSString *homeDir = NSHomeDirectory();
    NSString *documentsDir = [homeDir stringByAppendingPathComponent:@"Documents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentsDir]) {
        [fileManager createDirectoryAtPath:documentsDir
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    return documentsDir;
#elif SS_PLATFORM_WINDOWS
    // On Windows, use Documents folder
    NSString *documentsDir = [SSWindowsPlatform windowsDocumentsPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentsDir]) {
        [fileManager createDirectoryAtPath:documentsDir
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    return documentsDir;
#else
    return NSHomeDirectory();
#endif
}

- (NSString *)cacheDirectory {
#if SS_PLATFORM_MACOS || SS_PLATFORM_IOS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
#elif SS_PLATFORM_LINUX
    // On Linux, use ~/.cache or XDG_CACHE_HOME
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    NSString *cacheHome = [env objectForKey:@"XDG_CACHE_HOME"];
    if (!cacheHome || cacheHome.length == 0) {
        cacheHome = [NSHomeDirectory() stringByAppendingPathComponent:@".cache"];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheHome]) {
        [fileManager createDirectoryAtPath:cacheHome
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    return cacheHome;
#elif SS_PLATFORM_WINDOWS
    // On Windows, use LocalAppData for cache
    NSString *cacheDir = [SSWindowsPlatform windowsLocalAppDataPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheDir]) {
        [fileManager createDirectoryAtPath:cacheDir
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    return cacheDir;
#else
    return [self temporaryDirectory];
#endif
}

- (NSString *)temporaryDirectory {
#if SS_PLATFORM_WINDOWS
    return [SSWindowsPlatform windowsTempPath];
#else
    return NSTemporaryDirectory();
#endif
}

- (NSString *)applicationSupportDirectory {
#if SS_PLATFORM_MACOS || SS_PLATFORM_IOS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupport = paths.firstObject;
    
    // Append app name/bundle identifier
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    if (!bundleId) {
        bundleId = @"SmallStep";
    }
    NSString *appDir = [appSupport stringByAppendingPathComponent:bundleId];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:appDir]) {
        [fileManager createDirectoryAtPath:appDir
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    return appDir;
#elif SS_PLATFORM_LINUX
    // On Linux, use ~/.local/share or XDG_DATA_HOME
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    NSString *dataHome = [env objectForKey:@"XDG_DATA_HOME"];
    if (!dataHome || dataHome.length == 0) {
        dataHome = [[NSHomeDirectory() stringByAppendingPathComponent:@".local"] stringByAppendingPathComponent:@"share"];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dataHome]) {
        [fileManager createDirectoryAtPath:dataHome
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    return dataHome;
#elif SS_PLATFORM_WINDOWS
    // On Windows, use AppData\Roaming for application support
    NSString *appDataPath = [SSWindowsPlatform windowsAppDataPath];
    
    // Append app name/bundle identifier
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    if (!bundleId) {
        bundleId = @"SmallStep";
    }
    NSString *appDir = [appDataPath stringByAppendingPathComponent:bundleId];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:appDir]) {
        [fileManager createDirectoryAtPath:appDir
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    return appDir;
#else
    return [self documentsDirectory];
#endif
}

- (BOOL)fileExistsAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

- (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:path
                 withIntermediateDirectories:YES
                                  attributes:nil
                                       error:error];
}

- (NSData *)readFileAtPath:(NSString *)path error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        if (error) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"File does not exist"
                                                                 forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"SSFileSystem"
                                          code:1
                                      userInfo:userInfo];
        }
        return nil;
    }
    return [NSData dataWithContentsOfFile:path];
}

- (BOOL)writeData:(NSData *)data toPath:(NSString *)path error:(NSError **)error {
    return [data writeToFile:path atomically:YES];
}

- (BOOL)writeString:(NSString *)string toPath:(NSString *)path error:(NSError **)error {
    return [string writeToFile:path
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:error];
}

- (BOOL)deleteFileAtPath:(NSString *)path error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:error];
}

- (NSArray *)listFilesInDirectory:(NSString *)path error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsOfDirectoryAtPath:path error:error];
}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager attributesOfItemAtPath:path error:error];
}

@end
