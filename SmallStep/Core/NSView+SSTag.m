//
//  NSView+SSTag.m
//  SmallStep
//
//  GNUstep-only implementation of -setTag:, -tag, -viewWithTag: for NSView
//  using associated objects.
//

#if !defined(__APPLE__)

#import "NSView+SSTag.h"
#import <objc/runtime.h>

#ifndef OBJC_ASSOCIATION_RETAIN_NONATOMIC
#  define OBJC_ASSOCIATION_RETAIN_NONATOMIC 1
#endif

static const void *kSSTagKey = &kSSTagKey;

@implementation NSView (SSTag)

- (void) setTag: (NSInteger)tag
{
	objc_setAssociatedObject(self, kSSTagKey,
		[NSNumber numberWithInteger: tag],
		OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger) tag
{
	NSNumber *n = objc_getAssociatedObject(self, kSSTagKey);
	return n ? [n integerValue] : 0;
}

@end

#endif
