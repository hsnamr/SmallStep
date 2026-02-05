//
//  SSHostApplication.h
//  SmallStep
//
//  Cross-platform application host: run loop and delegate forwarding (GNUStep/Linux, AppKit/macOS, UIKit/iOS).
//

#import <Foundation/Foundation.h>

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

#import "SSAppDelegate.h"

#if defined(GNUSTEP)
#  define SS_NULLABLE
#  define SS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END
#else
#  define SS_NULLABLE nullable
#  define SS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

SS_ASSUME_NONNULL_BEGIN

/// Cross-platform application host.
/// On desktop (GNUStep/macOS): call runWithDelegate: to start NSApplication and forward lifecycle to your SSAppDelegate.
/// On iOS: set the app delegate with setAppDelegate: before UIApplicationMain; the iOS app delegate should forward to it.
@interface SSHostApplication : NSObject

/// Shared host application instance.
+ (instancetype)sharedHostApplication;

/// App delegate (your cross-platform logic). Set before run (desktop) or before UIApplicationMain (iOS).
#if defined(GNUSTEP)
@property (nonatomic, assign) id<SSAppDelegate> appDelegate;
#else
@property (nonatomic, weak, nullable) id<SSAppDelegate> appDelegate;
#endif

/// On desktop (GNUStep/macOS): sets appDelegate, sets up NSApplication delegate, and runs the app. Does not return until app quits.
/// On iOS: only sets appDelegate; use UIApplicationMain and forward from your UIApplicationDelegate to appDelegate.
+ (void)runWithDelegate:(id<SSAppDelegate>)delegate;

/// Convenience: set app delegate (e.g. from iOS main before UIApplicationMain).
+ (void)setAppDelegate:(id<SSAppDelegate>)delegate;

/// Get current app delegate.
+ (id<SSAppDelegate>)appDelegate;

@end

SS_ASSUME_NONNULL_END
