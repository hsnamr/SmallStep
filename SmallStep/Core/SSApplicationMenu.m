//
//  SSApplicationMenu.m
//  SmallStep
//
//  Cross-platform application menu implementation
//

#import "SSApplicationMenu.h"
#import "SSPlatform.h"

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif

#if defined(__GNUSTEP__) || defined(__linux__)
#import <AppKit/AppKit.h>
#endif

@implementation SSApplicationMenu

@synthesize delegate;

- (instancetype)initWithDelegate:(id<SSApplicationMenuDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)buildMenu {
    if ([SSPlatform isMacOS]) {
        [self buildMacOSMenu];
    } else if ([SSPlatform isLinux]) {
        [self buildLinuxMenu];
    }
    // iOS and Windows don't use traditional menus
}

- (void)buildMacOSMenu {
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
    // Create main menu bar
    mainMenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];
    
    // App menu (macOS convention)
    NSMenu *appMenu = [[NSMenu alloc] initWithTitle:@"Small Barcode Reader"];
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] initWithTitle:@"Small Barcode Reader" action:NULL keyEquivalent:@""];
    [appMenuItem setSubmenu:appMenu];
    [mainMenu addItem:appMenuItem];
    [appMenuItem release];
    
    // About item
    NSMenuItem *aboutItem = [[NSMenuItem alloc] initWithTitle:@"About Small Barcode Reader" action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    [aboutItem setTarget:NSApp];
    [appMenu addItem:aboutItem];
    [aboutItem release];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Quit item
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit Small Barcode Reader" action:@selector(terminate:) keyEquivalent:@"q"];
    [quitItem setTarget:NSApp];
    [appMenu addItem:quitItem];
    [quitItem release];
    [appMenu release];
    
    // File Menu
    fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
    NSMenuItem *openItem = [[NSMenuItem alloc] initWithTitle:@"Open Image..." action:@selector(menuOpenImage:) keyEquivalent:@"o"];
    [openItem setTarget:self];
    [fileMenu addItem:openItem];
    [openItem release];
    
    NSMenuItem *saveItem = [[NSMenuItem alloc] initWithTitle:@"Save Image..." action:@selector(menuSaveImage:) keyEquivalent:@"s"];
    [saveItem setTarget:self];
    [fileMenu addItem:saveItem];
    [saveItem release];
    
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] initWithTitle:@"File" action:NULL keyEquivalent:@""];
    [fileMenuItem setSubmenu:fileMenu];
    [mainMenu addItem:fileMenuItem];
    [fileMenuItem release];
    
    // Decode Menu
    decodeMenu = [[NSMenu alloc] initWithTitle:@"Decode"];
    NSMenuItem *decodeItem = [[NSMenuItem alloc] initWithTitle:@"Decode Barcode" action:@selector(menuDecodeImage:) keyEquivalent:@"d"];
    [decodeItem setTarget:self];
    [decodeMenu addItem:decodeItem];
    [decodeItem release];
    
    NSMenuItem *decodeMenuItem = [[NSMenuItem alloc] initWithTitle:@"Decode" action:NULL keyEquivalent:@""];
    [decodeMenuItem setSubmenu:decodeMenu];
    [mainMenu addItem:decodeMenuItem];
    [decodeMenuItem release];
    
    // Encode Menu
    encodeMenu = [[NSMenu alloc] initWithTitle:@"Encode"];
    NSMenuItem *encodeItem = [[NSMenuItem alloc] initWithTitle:@"Encode Barcode" action:@selector(menuEncodeBarcode:) keyEquivalent:@"e"];
    [encodeItem setTarget:self];
    [encodeMenu addItem:encodeItem];
    [encodeItem release];
    
    NSMenuItem *encodeMenuItem = [[NSMenuItem alloc] initWithTitle:@"Encode" action:NULL keyEquivalent:@""];
    [encodeMenuItem setSubmenu:encodeMenu];
    [mainMenu addItem:encodeMenuItem];
    [encodeMenuItem release];
    
    // Distortion Menu
    distortionMenu = [[NSMenu alloc] initWithTitle:@"Distortion"];
    NSMenuItem *applyItem = [[NSMenuItem alloc] initWithTitle:@"Apply Distortion" action:@selector(menuApplyDistortion:) keyEquivalent:@""];
    [applyItem setTarget:self];
    [distortionMenu addItem:applyItem];
    [applyItem release];
    
    NSMenuItem *previewItem = [[NSMenuItem alloc] initWithTitle:@"Preview Distortion" action:@selector(menuPreviewDistortion:) keyEquivalent:@""];
    [previewItem setTarget:self];
    [distortionMenu addItem:previewItem];
    [previewItem release];
    
    NSMenuItem *clearItem = [[NSMenuItem alloc] initWithTitle:@"Clear Distortion" action:@selector(menuClearDistortion:) keyEquivalent:@""];
    [clearItem setTarget:self];
    [distortionMenu addItem:clearItem];
    [clearItem release];
    
    NSMenuItem *distortionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Distortion" action:NULL keyEquivalent:@""];
    [distortionMenuItem setSubmenu:distortionMenu];
    [mainMenu addItem:distortionMenuItem];
    [distortionMenuItem release];
    
    // Testing Menu
    testingMenu = [[NSMenu alloc] initWithTitle:@"Testing"];
    NSMenuItem *testItem = [[NSMenuItem alloc] initWithTitle:@"Test Decodability" action:@selector(menuTestDecodability:) keyEquivalent:@""];
    [testItem setTarget:self];
    [testingMenu addItem:testItem];
    [testItem release];
    
    NSMenuItem *progressiveItem = [[NSMenuItem alloc] initWithTitle:@"Run Progressive Test" action:@selector(menuRunProgressiveTest:) keyEquivalent:@""];
    [progressiveItem setTarget:self];
    [testingMenu addItem:progressiveItem];
    [progressiveItem release];
    
    NSMenuItem *exportItem = [[NSMenuItem alloc] initWithTitle:@"Export Test Results..." action:@selector(menuExportTestResults:) keyEquivalent:@""];
    [exportItem setTarget:self];
    [testingMenu addItem:exportItem];
    [exportItem release];
    
    NSMenuItem *testingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Testing" action:NULL keyEquivalent:@""];
    [testingMenuItem setSubmenu:testingMenu];
    [mainMenu addItem:testingMenuItem];
    [testingMenuItem release];
    
    // Library Menu
    libraryMenu = [[NSMenu alloc] initWithTitle:@"Library"];
    NSMenuItem *loadLibraryItem = [[NSMenuItem alloc] initWithTitle:@"Load Library..." action:@selector(menuLoadLibrary:) keyEquivalent:@""];
    [loadLibraryItem setTarget:self];
    [libraryMenu addItem:loadLibraryItem];
    [loadLibraryItem release];
    
    NSMenuItem *libraryMenuItem = [[NSMenuItem alloc] initWithTitle:@"Library" action:NULL keyEquivalent:@""];
    [libraryMenuItem setSubmenu:libraryMenu];
    [mainMenu addItem:libraryMenuItem];
    [libraryMenuItem release];
    
    // Set as main menu
    [NSApp setMainMenu:mainMenu];
#endif
}

- (void)buildLinuxMenu {
#if defined(__GNUSTEP__) || defined(__linux__)
    // Also create a main menu for GNUstep (for keyboard shortcuts)
    // Even though we use a floating panel, the main menu is needed for key equivalents
    mainMenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];
    
    // File Menu
    fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
    NSMenuItem *openItem = [[NSMenuItem alloc] initWithTitle:@"Open Image..." action:@selector(menuOpenImage:) keyEquivalent:@"o"];
    [openItem setTarget:self];
    [fileMenu addItem:openItem];
    [openItem release];
    
    NSMenuItem *saveItem = [[NSMenuItem alloc] initWithTitle:@"Save Image..." action:@selector(menuSaveImage:) keyEquivalent:@"s"];
    [saveItem setTarget:self];
    [fileMenu addItem:saveItem];
    [saveItem release];
    
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] initWithTitle:@"File" action:NULL keyEquivalent:@""];
    [fileMenuItem setSubmenu:fileMenu];
    [mainMenu addItem:fileMenuItem];
    [fileMenuItem release];
    
    // Decode Menu
    decodeMenu = [[NSMenu alloc] initWithTitle:@"Decode"];
    NSMenuItem *decodeItem = [[NSMenuItem alloc] initWithTitle:@"Decode Barcode" action:@selector(menuDecodeImage:) keyEquivalent:@"d"];
    [decodeItem setTarget:self];
    [decodeMenu addItem:decodeItem];
    [decodeItem release];
    
    NSMenuItem *decodeMenuItem = [[NSMenuItem alloc] initWithTitle:@"Decode" action:NULL keyEquivalent:@""];
    [decodeMenuItem setSubmenu:decodeMenu];
    [mainMenu addItem:decodeMenuItem];
    [decodeMenuItem release];
    
    // Encode Menu
    encodeMenu = [[NSMenu alloc] initWithTitle:@"Encode"];
    NSMenuItem *encodeItem = [[NSMenuItem alloc] initWithTitle:@"Encode Barcode" action:@selector(menuEncodeBarcode:) keyEquivalent:@"e"];
    [encodeItem setTarget:self];
    [encodeMenu addItem:encodeItem];
    [encodeItem release];
    
    NSMenuItem *encodeMenuItem = [[NSMenuItem alloc] initWithTitle:@"Encode" action:NULL keyEquivalent:@""];
    [encodeMenuItem setSubmenu:encodeMenu];
    [mainMenu addItem:encodeMenuItem];
    [encodeMenuItem release];
    
    // Distortion Menu
    distortionMenu = [[NSMenu alloc] initWithTitle:@"Distortion"];
    NSMenuItem *applyItem = [[NSMenuItem alloc] initWithTitle:@"Apply Distortion" action:@selector(menuApplyDistortion:) keyEquivalent:@""];
    [applyItem setTarget:self];
    [distortionMenu addItem:applyItem];
    [applyItem release];
    
    NSMenuItem *previewItem = [[NSMenuItem alloc] initWithTitle:@"Preview Distortion" action:@selector(menuPreviewDistortion:) keyEquivalent:@""];
    [previewItem setTarget:self];
    [distortionMenu addItem:previewItem];
    [previewItem release];
    
    NSMenuItem *clearItem = [[NSMenuItem alloc] initWithTitle:@"Clear Distortion" action:@selector(menuClearDistortion:) keyEquivalent:@""];
    [clearItem setTarget:self];
    [distortionMenu addItem:clearItem];
    [clearItem release];
    
    NSMenuItem *distortionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Distortion" action:NULL keyEquivalent:@""];
    [distortionMenuItem setSubmenu:distortionMenu];
    [mainMenu addItem:distortionMenuItem];
    [distortionMenuItem release];
    
    // Testing Menu
    testingMenu = [[NSMenu alloc] initWithTitle:@"Testing"];
    NSMenuItem *testItem = [[NSMenuItem alloc] initWithTitle:@"Test Decodability" action:@selector(menuTestDecodability:) keyEquivalent:@""];
    [testItem setTarget:self];
    [testingMenu addItem:testItem];
    [testItem release];
    
    NSMenuItem *progressiveItem = [[NSMenuItem alloc] initWithTitle:@"Run Progressive Test" action:@selector(menuRunProgressiveTest:) keyEquivalent:@""];
    [progressiveItem setTarget:self];
    [testingMenu addItem:progressiveItem];
    [progressiveItem release];
    
    NSMenuItem *exportItem = [[NSMenuItem alloc] initWithTitle:@"Export Test Results..." action:@selector(menuExportTestResults:) keyEquivalent:@""];
    [exportItem setTarget:self];
    [testingMenu addItem:exportItem];
    [exportItem release];
    
    NSMenuItem *testingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Testing" action:NULL keyEquivalent:@""];
    [testingMenuItem setSubmenu:testingMenu];
    [mainMenu addItem:testingMenuItem];
    [testingMenuItem release];
    
    // Library Menu
    libraryMenu = [[NSMenu alloc] initWithTitle:@"Library"];
    NSMenuItem *loadLibraryItem = [[NSMenuItem alloc] initWithTitle:@"Load Library..." action:@selector(menuLoadLibrary:) keyEquivalent:@""];
    [loadLibraryItem setTarget:self];
    [libraryMenu addItem:loadLibraryItem];
    [loadLibraryItem release];
    
    NSMenuItem *libraryMenuItem = [[NSMenuItem alloc] initWithTitle:@"Library" action:NULL keyEquivalent:@""];
    [libraryMenuItem setSubmenu:libraryMenu];
    [mainMenu addItem:libraryMenuItem];
    [libraryMenuItem release];
    
    // Set main menu for keyboard shortcuts (even if not visible as menu bar)
    [NSApp setMainMenu:mainMenu];
    
    // Create floating panel for GNUstep (visual menu)
    NSRect panelRect = NSMakeRect(50, 50, 300, 400);
    NSUInteger styleMask = NSTitledWindowMask | NSClosableWindowMask;
#if defined(NSUtilityWindowMask)
    styleMask |= NSUtilityWindowMask;
#elif defined(NSWindowStyleMaskUtilityWindow)
    styleMask |= NSWindowStyleMaskUtilityWindow;
#endif
    
    floatingPanel = [[NSPanel alloc] initWithContentRect:panelRect
                                                 styleMask:styleMask
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
    [floatingPanel setTitle:@"Control Menu"];
    [floatingPanel setFloatingPanel:YES];
    [floatingPanel setLevel:NSFloatingWindowLevel];
    [floatingPanel setHidesOnDeactivate:NO];
    [floatingPanel setBecomesKeyOnlyIfNeeded:YES];
    // Make sure panel is released when closed
    [floatingPanel setReleasedWhenClosed:NO];
    
    // Create scroll view
    NSView *contentView = [floatingPanel contentView];
    NSRect bounds = [contentView bounds];
    [contentView setAutoresizesSubviews:YES];
    
    scrollView = [[NSScrollView alloc] initWithFrame:bounds];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:NO];
    [scrollView setAutohidesScrollers:YES];
    [scrollView setBorderType:NSBezelBorder];
    [scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // Create container view
    containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, bounds.size.width - 20, 0)];
    
    float currentY = 10;
    float buttonHeight = 28;
    float spacing = 5;
    float buttonWidth = bounds.size.width - 40;
    
    // File section
    [self addSectionLabel:@"File" toView:containerView atY:&currentY width:buttonWidth];
    [self addButton:@"Open Image..." action:@selector(menuOpenImage:) keyEquivalent:@"o" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing];
    [self addButton:@"Save Image..." action:@selector(menuSaveImage:) keyEquivalent:@"s" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing + 10];
    
    // Decode section
    [self addSectionLabel:@"Decode" toView:containerView atY:&currentY width:buttonWidth];
    [self addButton:@"Decode Barcode" action:@selector(menuDecodeImage:) keyEquivalent:@"d" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing + 10];
    
    // Encode section
    [self addSectionLabel:@"Encode" toView:containerView atY:&currentY width:buttonWidth];
    [self addButton:@"Encode Barcode" action:@selector(menuEncodeBarcode:) keyEquivalent:@"e" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing + 10];
    
    // Distortion section
    [self addSectionLabel:@"Distortion" toView:containerView atY:&currentY width:buttonWidth];
    [self addButton:@"Apply Distortion" action:@selector(menuApplyDistortion:) keyEquivalent:@"" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing];
    [self addButton:@"Preview Distortion" action:@selector(menuPreviewDistortion:) keyEquivalent:@"" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing];
    [self addButton:@"Clear Distortion" action:@selector(menuClearDistortion:) keyEquivalent:@"" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing + 10];
    
    // Testing section
    [self addSectionLabel:@"Testing" toView:containerView atY:&currentY width:buttonWidth];
    [self addButton:@"Test Decodability" action:@selector(menuTestDecodability:) keyEquivalent:@"" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing];
    [self addButton:@"Run Progressive Test" action:@selector(menuRunProgressiveTest:) keyEquivalent:@"" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing];
    [self addButton:@"Export Test Results..." action:@selector(menuExportTestResults:) keyEquivalent:@"" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing + 10];
    
    // Library section
    [self addSectionLabel:@"Library" toView:containerView atY:&currentY width:buttonWidth];
    [self addButton:@"Load Library..." action:@selector(menuLoadLibrary:) keyEquivalent:@"" toView:containerView atY:&currentY width:buttonWidth height:buttonHeight spacing:spacing + 10];
    
    // Update container view height
    [containerView setFrame:NSMakeRect(0, 0, bounds.size.width - 20, currentY)];
    
    [scrollView setDocumentView:containerView];
    [contentView addSubview:scrollView];
    
    // Ensure panel is properly configured for GNUstep
    // Panel should be visible but not steal focus
    [floatingPanel setWorksWhenModal:YES];
#endif
}

- (void)addSectionLabel:(NSString *)title toView:(NSView *)view atY:(float *)y width:(float)width {
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(10, *y, width, 20)];
    [label setStringValue:title];
    [label setEditable:NO];
    [label setBordered:NO];
    [label setBackgroundColor:[NSColor controlBackgroundColor]];
    [label setFont:[NSFont boldSystemFontOfSize:12]];
    [view addSubview:label];
    [label release];
    *y += 25;
}

- (void)addButton:(NSString *)title action:(SEL)action keyEquivalent:(NSString *)keyEq toView:(NSView *)view atY:(float *)y width:(float)width height:(float)height spacing:(float)spacing {
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(10, *y, width, height)];
    [button setTitle:title];
    [button setButtonType:NSMomentaryPushInButton];
    [button setBezelStyle:NSRoundedBezelStyle];
    [button setTarget:self];
    [button setAction:action];
    if ([keyEq length] > 0) {
        [button setKeyEquivalent:keyEq];
        [button setKeyEquivalentModifierMask:NSCommandKeyMask];
    }
    [view addSubview:button];
    [button release];
    *y += (height + spacing);
}

- (void)updateMenuStates {
    if (!self.delegate) {
        return;
    }
    
    if ([SSPlatform isMacOS]) {
        [self updateMacOSMenuStates];
    } else if ([SSPlatform isLinux]) {
        [self updateLinuxMenuStates];
    }
}

- (void)updateMacOSMenuStates {
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
    // Update file menu
    if ([self.delegate respondsToSelector:@selector(isSaveImageEnabled)]) {
        NSMenuItem *saveItem = [[fileMenu itemArray] objectAtIndex:1];
        if (saveItem) {
            [saveItem setEnabled:[self.delegate isSaveImageEnabled]];
        }
    }
    
    // Update decode menu
    if ([self.delegate respondsToSelector:@selector(isDecodeImageEnabled)]) {
        NSMenuItem *decodeItem = [[decodeMenu itemArray] objectAtIndex:0];
        if (decodeItem) {
            [decodeItem setEnabled:[self.delegate isDecodeImageEnabled]];
        }
    }
    
    // Update encode menu
    if ([self.delegate respondsToSelector:@selector(isEncodeBarcodeEnabled)]) {
        NSMenuItem *encodeItem = [[encodeMenu itemArray] objectAtIndex:0];
        if (encodeItem) {
            [encodeItem setEnabled:[self.delegate isEncodeBarcodeEnabled]];
        }
    }
    
    // Update distortion menu
    if ([self.delegate respondsToSelector:@selector(isApplyDistortionEnabled)]) {
        NSMenuItem *applyItem = [[distortionMenu itemArray] objectAtIndex:0];
        if (applyItem) {
            [applyItem setEnabled:[self.delegate isApplyDistortionEnabled]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(isPreviewDistortionEnabled)]) {
        NSMenuItem *previewItem = [[distortionMenu itemArray] objectAtIndex:1];
        if (previewItem) {
            [previewItem setEnabled:[self.delegate isPreviewDistortionEnabled]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(isClearDistortionEnabled)]) {
        NSMenuItem *clearItem = [[distortionMenu itemArray] objectAtIndex:2];
        if (clearItem) {
            [clearItem setEnabled:[self.delegate isClearDistortionEnabled]];
        }
    }
    
    // Update testing menu
    if ([self.delegate respondsToSelector:@selector(isTestDecodabilityEnabled)]) {
        NSMenuItem *testItem = [[testingMenu itemArray] objectAtIndex:0];
        if (testItem) {
            [testItem setEnabled:[self.delegate isTestDecodabilityEnabled]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(isRunProgressiveTestEnabled)]) {
        NSMenuItem *progressiveItem = [[testingMenu itemArray] objectAtIndex:1];
        if (progressiveItem) {
            [progressiveItem setEnabled:[self.delegate isRunProgressiveTestEnabled]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(isExportTestResultsEnabled)]) {
        NSMenuItem *exportItem = [[testingMenu itemArray] objectAtIndex:2];
        if (exportItem) {
            [exportItem setEnabled:[self.delegate isExportTestResultsEnabled]];
        }
    }
#endif
}

- (void)updateLinuxMenuStates {
#if defined(__GNUSTEP__) || defined(__linux__)
    // Update button states in floating panel
    NSArray *buttons = [containerView subviews];
    for (NSView *view in buttons) {
        if ([view isKindOfClass:[NSButton class]]) {
            NSButton *button = (NSButton *)view;
            SEL action = [button action];
            
            BOOL enabled = YES;
            if (action == @selector(menuSaveImage:)) {
                enabled = [self.delegate respondsToSelector:@selector(isSaveImageEnabled)] ? [self.delegate isSaveImageEnabled] : YES;
            } else if (action == @selector(menuDecodeImage:)) {
                enabled = [self.delegate respondsToSelector:@selector(isDecodeImageEnabled)] ? [self.delegate isDecodeImageEnabled] : YES;
            } else if (action == @selector(menuEncodeBarcode:)) {
                enabled = [self.delegate respondsToSelector:@selector(isEncodeBarcodeEnabled)] ? [self.delegate isEncodeBarcodeEnabled] : YES;
            } else if (action == @selector(menuApplyDistortion:)) {
                enabled = [self.delegate respondsToSelector:@selector(isApplyDistortionEnabled)] ? [self.delegate isApplyDistortionEnabled] : YES;
            } else if (action == @selector(menuPreviewDistortion:)) {
                enabled = [self.delegate respondsToSelector:@selector(isPreviewDistortionEnabled)] ? [self.delegate isPreviewDistortionEnabled] : YES;
            } else if (action == @selector(menuClearDistortion:)) {
                enabled = [self.delegate respondsToSelector:@selector(isClearDistortionEnabled)] ? [self.delegate isClearDistortionEnabled] : YES;
            } else if (action == @selector(menuTestDecodability:)) {
                enabled = [self.delegate respondsToSelector:@selector(isTestDecodabilityEnabled)] ? [self.delegate isTestDecodabilityEnabled] : YES;
            } else if (action == @selector(menuRunProgressiveTest:)) {
                enabled = [self.delegate respondsToSelector:@selector(isRunProgressiveTestEnabled)] ? [self.delegate isRunProgressiveTestEnabled] : YES;
            } else if (action == @selector(menuExportTestResults:)) {
                enabled = [self.delegate respondsToSelector:@selector(isExportTestResultsEnabled)] ? [self.delegate isExportTestResultsEnabled] : YES;
            }
            
            [button setEnabled:enabled];
        }
    }
#endif
}

- (void)showMenu {
    if ([SSPlatform isLinux]) {
#if defined(__GNUSTEP__) || defined(__linux__)
        if (floatingPanel) {
            // Make sure panel is visible and on top
            [floatingPanel orderFront:nil];
            [floatingPanel makeKeyAndOrderFront:nil];
            // Ensure it stays on top
            [floatingPanel setLevel:NSFloatingWindowLevel];
            [self updateMenuStates];
        }
#endif
    }
}

- (void)hideMenu {
    if ([SSPlatform isLinux]) {
#if defined(__GNUSTEP__) || defined(__linux__)
        [floatingPanel orderOut:nil];
#endif
    }
}

- (void)toggleMenu {
    if ([SSPlatform isLinux]) {
#if defined(__GNUSTEP__) || defined(__linux__)
        if ([floatingPanel isVisible]) {
            [self hideMenu];
        } else {
            [self showMenu];
        }
#endif
    }
}

// Menu action handlers - forward to delegate
- (void)menuOpenImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuOpenImage:)]) {
        [self.delegate menuOpenImage:sender];
    }
}

- (void)menuSaveImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuSaveImage:)]) {
        [self.delegate menuSaveImage:sender];
    }
}

- (void)menuDecodeImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuDecodeImage:)]) {
        [self.delegate menuDecodeImage:sender];
    }
}

- (void)menuEncodeBarcode:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuEncodeBarcode:)]) {
        [self.delegate menuEncodeBarcode:sender];
    }
}

- (void)menuApplyDistortion:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuApplyDistortion:)]) {
        [self.delegate menuApplyDistortion:sender];
    }
}

- (void)menuPreviewDistortion:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuPreviewDistortion:)]) {
        [self.delegate menuPreviewDistortion:sender];
    }
}

- (void)menuClearDistortion:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuClearDistortion:)]) {
        [self.delegate menuClearDistortion:sender];
    }
}

- (void)menuTestDecodability:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuTestDecodability:)]) {
        [self.delegate menuTestDecodability:sender];
    }
}

- (void)menuRunProgressiveTest:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuRunProgressiveTest:)]) {
        [self.delegate menuRunProgressiveTest:sender];
    }
}

- (void)menuExportTestResults:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuExportTestResults:)]) {
        [self.delegate menuExportTestResults:sender];
    }
}

- (void)menuLoadLibrary:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuLoadLibrary:)]) {
        [self.delegate menuLoadLibrary:sender];
    }
}

- (void)dealloc {
#if defined(__GNUSTEP__) || defined(__linux__)
    [floatingPanel release];
    [containerView release];
    [scrollView release];
#endif
    [mainMenu release];
    [fileMenu release];
    [decodeMenu release];
    [encodeMenu release];
    [distortionMenu release];
    [testingMenu release];
    [libraryMenu release];
    [super dealloc];
}

@end
