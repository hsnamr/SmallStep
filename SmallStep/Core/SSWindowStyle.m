//
//  SSWindowStyle.m
//  SmallStep
//
//  Cross-platform window style implementation
//

#import "SSWindowStyle.h"
#import "SSPlatform.h"

@implementation SSWindowStyle

+ (NSUInteger)standardWindowMask {
    return [self titledWindowMask] | [self closableWindowMask] | 
           [self miniaturizableWindowMask] | [self resizableWindowMask];
}

+ (NSUInteger)titledWindowMask {
#if defined(GNUSTEP_BASE_VERSION) || defined(__GNUSTEP__)
    return NSTitledWindowMask;
#elif TARGET_OS_MAC && !TARGET_OS_IPHONE
    if (@available(macOS 10.12, *)) {
        return NSWindowStyleMaskTitled;
    } else {
        return NSTitledWindowMask;
    }
#else
    return NSTitledWindowMask;
#endif
}

+ (NSUInteger)closableWindowMask {
#if defined(GNUSTEP_BASE_VERSION) || defined(__GNUSTEP__)
    return NSClosableWindowMask;
#elif TARGET_OS_MAC && !TARGET_OS_IPHONE
    if (@available(macOS 10.12, *)) {
        return NSWindowStyleMaskClosable;
    } else {
        return NSClosableWindowMask;
    }
#else
    return NSClosableWindowMask;
#endif
}

+ (NSUInteger)miniaturizableWindowMask {
#if defined(GNUSTEP_BASE_VERSION) || defined(__GNUSTEP__)
    return NSMiniaturizableWindowMask;
#elif TARGET_OS_MAC && !TARGET_OS_IPHONE
    if (@available(macOS 10.12, *)) {
        return NSWindowStyleMaskMiniaturizable;
    } else {
        return NSMiniaturizableWindowMask;
    }
#else
    return NSMiniaturizableWindowMask;
#endif
}

+ (NSUInteger)resizableWindowMask {
#if defined(GNUSTEP_BASE_VERSION) || defined(__GNUSTEP__)
    return NSResizableWindowMask;
#elif TARGET_OS_MAC && !TARGET_OS_IPHONE
    if (@available(macOS 10.12, *)) {
        return NSWindowStyleMaskResizable;
    } else {
        return NSResizableWindowMask;
    }
#else
    return NSResizableWindowMask;
#endif
}

@end
