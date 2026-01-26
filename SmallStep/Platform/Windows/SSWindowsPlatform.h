//
//  SSWindowsPlatform.h
//  SmallStep
//
//  Windows (WinObjC) specific platform implementations

#import <Foundation/Foundation.h>
#import "SSPlatform.h"

NS_ASSUME_NONNULL_BEGIN

/// Windows-specific platform utilities
@interface SSWindowsPlatform : NSObject

/// Get Windows Documents folder path
+ (NSString *)windowsDocumentsPath;

/// Get Windows LocalAppData folder path
+ (NSString *)windowsLocalAppDataPath;

/// Get Windows AppData folder path
+ (NSString *)windowsAppDataPath;

/// Get Windows Temp folder path
+ (NSString *)windowsTempPath;

@end

NS_ASSUME_NONNULL_END
