//
//  SSiOSPlatform.h
//  SmallStep
//
//  iOS-specific platform implementations

#import <Foundation/Foundation.h>
#import "SSPlatform.h"

NS_ASSUME_NONNULL_BEGIN

/// iOS-specific platform utilities
@interface SSiOSPlatform : NSObject

/// Get iOS documents directory (shared container if in app group)
+ (NSString *)iOSDocumentsDirectory;

/// Check if running in app extension
+ (BOOL)isAppExtension;

@end

NS_ASSUME_NONNULL_END
