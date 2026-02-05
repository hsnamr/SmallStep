//
//  SSMainMenu.m
//  SmallStep
//
//  Generic desktop application menu implementation (GNUStep/macOS).
//

#import "SSMainMenu.h"

#if !TARGET_OS_IPHONE

#import "SSPlatform.h"

@implementation SSMainMenuItem
#if defined(GNUSTEP) && !__has_feature(objc_arc)
@synthesize title = _title;
@synthesize action = _action;
@synthesize keyEquivalent = _keyEquivalent;
@synthesize keyEquivalentModifierMask = _keyEquivalentModifierMask;
@synthesize target = _target;
#else
@synthesize title;
@synthesize action;
@synthesize keyEquivalent;
@synthesize keyEquivalentModifierMask;
@synthesize target;
#endif

+ (instancetype)itemWithTitle:(NSString *)title action:(SEL)action keyEquivalent:(NSString *)keyEquiv modifierMask:(NSUInteger)mask target:(id)target {
    SSMainMenuItem *item = [[self alloc] init];
    item.title = title;
    item.action = action;
    item.keyEquivalent = keyEquiv ?: @"";
    item.keyEquivalentModifierMask = mask;
    item.target = target;
    return [item autorelease];
}

@end

@implementation SSMainMenu
#if defined(GNUSTEP) && !__has_feature(objc_arc)
@synthesize appName = _appName;
#else
@synthesize appName;
#endif

- (void)buildMenuWithItems:(NSArray *)items
                 quitTitle:(NSString *)quitTitle
         quitKeyEquivalent:(NSString *)quitKeyEquivalent {
    NSString *appName = _appName.length ? _appName : @"App";
    NSMenu *mainMenu = [[NSMenu alloc] init];
    NSMenuItem *appItem = [[NSMenuItem alloc] init];
    [appItem setTitle:appName];
    NSMenu *appMenu = [[NSMenu alloc] initWithTitle:appName];

    for (SSMainMenuItem *desc in items) {
        NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:desc.title
                                                     action:desc.action
                                              keyEquivalent:desc.keyEquivalent ?: @""];
        [mi setKeyEquivalentModifierMask:desc.keyEquivalentModifierMask];
        [mi setTarget:desc.target ?: self];
        [appMenu addItem:mi];
        [mi release];
    }

    [appMenu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:quitTitle
                                                     action:@selector(terminate:)
                                              keyEquivalent:quitKeyEquivalent ?: @"q"];
    [quitItem setTarget:NSApp];
    [appMenu addItem:quitItem];
    [quitItem release];

    [appItem setSubmenu:appMenu];
    [appMenu release];
    [mainMenu addItem:appItem];
    [appItem release];

    [NSApp setMainMenu:mainMenu];
    [mainMenu release];
}

- (void)install {
    // Already installed in buildMenuWithItems: via [NSApp setMainMenu:]
}

@end

#endif
