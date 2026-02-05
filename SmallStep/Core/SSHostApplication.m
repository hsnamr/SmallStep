//
//  SSHostApplication.m
//  SmallStep
//
//  Cross-platform application host implementation.
//

#import "SSHostApplication.h"

#if !TARGET_OS_IPHONE

#pragma mark - Desktop (GNUStep / macOS): NSApplication adapter

@class SSHostApplicationAdapter;
static SSHostApplicationAdapter *s_desktopAdapter = nil;

@interface SSHostApplicationAdapter : NSObject <NSApplicationDelegate>
#if defined(GNUSTEP) && !__has_feature(objc_arc)
{
    id<SSAppDelegate> _appDelegate;
}
@property (nonatomic, assign) id<SSAppDelegate> appDelegate;  /* assign for GNUStep (no weak runtime) */
#else
@property (nonatomic, weak) id<SSAppDelegate> appDelegate;
#endif
@end

@implementation SSHostApplicationAdapter
@synthesize appDelegate = _appDelegate;

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    (void)notification;
    if ([_appDelegate respondsToSelector:@selector(applicationWillFinishLaunching)]) {
        [_appDelegate applicationWillFinishLaunching];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    (void)notification;
    if ([_appDelegate respondsToSelector:@selector(applicationDidFinishLaunching)]) {
        [_appDelegate applicationDidFinishLaunching];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    (void)notification;
    if ([_appDelegate respondsToSelector:@selector(applicationWillTerminate)]) {
        [_appDelegate applicationWillTerminate];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(id)sender {
    (void)sender;
    if ([_appDelegate respondsToSelector:@selector(applicationShouldTerminateAfterLastWindowClosed:)]) {
        return [_appDelegate applicationShouldTerminateAfterLastWindowClosed:sender];
    }
    return YES;
}

@end

#endif

#pragma mark - SSHostApplication

static id<SSAppDelegate> g_appDelegate = nil;

@implementation SSHostApplication
@dynamic appDelegate;
+ (id<SSAppDelegate>)appDelegate { return g_appDelegate; }
- (id<SSAppDelegate>)appDelegate { return g_appDelegate; }

+ (instancetype)sharedHostApplication {
    static SSHostApplication *shared = nil;
    if (shared == nil) {
        shared = [[self alloc] init];
    }
    return shared;
}

+ (void)setAppDelegate:(id<SSAppDelegate>)delegate {
    g_appDelegate = delegate;
    [[self sharedHostApplication] setAppDelegate:delegate];
}

+ (void)runWithDelegate:(id<SSAppDelegate>)delegate {
    [self setAppDelegate:delegate];

#if TARGET_OS_IPHONE
    // On iOS the app uses UIApplicationMain; the app delegate must forward to delegate.
    // So we only store the delegate here. Do not start a run loop.
    (void)delegate;
#else
    NSApplication *app = [NSApplication sharedApplication];
    if (s_desktopAdapter == nil) {
        s_desktopAdapter = [[SSHostApplicationAdapter alloc] init];
    }
    s_desktopAdapter.appDelegate = delegate;
    [app setDelegate:s_desktopAdapter];
    [app run];
#endif
}

- (void)setAppDelegate:(id<SSAppDelegate>)delegate {
    g_appDelegate = delegate;
}

@end
