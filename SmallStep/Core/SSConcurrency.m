//
//  SSConcurrency.m
//  SmallStep
//
//  Cross-platform concurrency implementation
//

#import "SSConcurrency.h"
#import "SSPlatform.h"

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <dispatch/dispatch.h>
#endif


@implementation SSConcurrency

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
+ (void)performInBackground:(void (^)(void))block {
    if (!block) {
        return;
    }
    // Use GCD on macOS
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

+ (void)performOnMainThread:(void (^)(void))block waitUntilDone:(BOOL)waitUntilDone {
    if (!block) {
        return;
    }
    // Use GCD on macOS
    if (waitUntilDone) {
        dispatch_sync(dispatch_get_main_queue(), block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
#endif

+ (void)performSelectorInBackground:(SEL)selector onTarget:(id)target withObject:(id)object {
    if (!target || !selector) {
        return;
    }
    
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
    // Use GCD on macOS
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [target performSelector:selector withObject:object];
    });
#else
    // Use NSThread on GNUstep
    [target performSelectorInBackground:selector withObject:object];
#endif
}

+ (void)performSelectorOnMainThread:(SEL)selector onTarget:(id)target withObject:(id)object waitUntilDone:(BOOL)waitUntilDone {
    if (!target || !selector) {
        return;
    }
    
    [target performSelectorOnMainThread:selector withObject:object waitUntilDone:waitUntilDone];
}

@end
