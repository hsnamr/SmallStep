//
//  NSView+SSTag.h
//  SmallStep
//
//  GNUstep compatibility: NSView -setTag: / -tag (and -viewWithTag: when missing).
//  On macOS these exist natively; on GNUstep this category provides them via
//  associated objects so apps can use [view setTag: N] and [view viewWithTag: N]
//  without respondsToSelector checks (e.g. SmallMarkdown, SmallBarcoder).
//

#import <AppKit/AppKit.h>

#if !defined(__APPLE__)
@interface NSView (SSTag)
- (void) setTag: (NSInteger)tag;
- (NSInteger) tag;
@end
#endif
