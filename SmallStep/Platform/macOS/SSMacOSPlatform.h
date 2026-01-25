//
//  SSMacOSPlatform.h
//  SmallStep
//
//  macOS-specific platform implementations

#import <Foundation/Foundation.h>
#import "SSPlatform.h"

NS_ASSUME_NONNULL_BEGIN

/// macOS-specific platform utilities
@interface SSMacOSPlatform : NSObject

/// Get macOS-specific application support path
+ (NSString *)macOSApplicationSupportPath;

/// Check if running in sandbox
+ (BOOL)isSandboxed;

@end

NS_ASSUME_NONNULL_END
