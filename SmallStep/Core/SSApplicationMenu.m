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
    
    // Add Quit menu item (following GNUstep guide pattern)
    [mainMenu addItemWithTitle:@"Quit" 
                        action:@selector(terminate:) 
                 keyEquivalent:@"q"];
    
    // Set main menu (following GNUstep guide: [NSApp setMainMenu: menu])
    [NSApp setMainMenu:mainMenu];
#endif
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
    // Update menu item states in main menu (same as macOS)
    // File menu
    if ([self.delegate respondsToSelector:@selector(isSaveImageEnabled)]) {
        NSMenuItem *saveItem = [[fileMenu itemArray] objectAtIndex:1];
        if (saveItem) {
            [saveItem setEnabled:[self.delegate isSaveImageEnabled]];
        }
    }
    
    // Decode menu
    if ([self.delegate respondsToSelector:@selector(isDecodeImageEnabled)]) {
        NSMenuItem *decodeItem = [[decodeMenu itemArray] objectAtIndex:0];
        if (decodeItem) {
            [decodeItem setEnabled:[self.delegate isDecodeImageEnabled]];
        }
    }
    
    // Encode menu
    if ([self.delegate respondsToSelector:@selector(isEncodeBarcodeEnabled)]) {
        NSMenuItem *encodeItem = [[encodeMenu itemArray] objectAtIndex:0];
        if (encodeItem) {
            [encodeItem setEnabled:[self.delegate isEncodeBarcodeEnabled]];
        }
    }
    
    // Distortion menu
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
    
    // Testing menu
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

- (void)showMenu {
    // No-op for GNUstep - main menu is always available
    if ([SSPlatform isLinux]) {
        // Main menu is handled by GNUstep automatically
    }
}

- (void)hideMenu {
    // No-op for GNUstep - main menu is always available
    if ([SSPlatform isLinux]) {
        // Main menu is handled by GNUstep automatically
    }
}

- (void)toggleMenu {
    // No-op for GNUstep - main menu is always available
    if ([SSPlatform isLinux]) {
        // Main menu is handled by GNUstep automatically
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
