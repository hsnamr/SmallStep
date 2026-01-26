//
//  SSFileDialog.m
//  SmallStep
//
//  Cross-platform file dialog implementation
//

#import "SSFileDialog.h"
#import "SSPlatform.h"

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif


@implementation SSFileDialog

+ (instancetype)openDialog {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allowsMultipleSelection = NO;
        _canChooseDirectories = NO;
        _canChooseFiles = YES;
        _allowedFileTypes = nil;
    }
    return self;
}

- (void)setAllowedFileTypes:(NSArray *)fileTypes {
    _allowedFileTypes = fileTypes;
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultiple {
    _allowsMultipleSelection = allowsMultiple;
}

- (void)setCanChooseDirectories:(BOOL)canChooseDirectories {
    _canChooseDirectories = canChooseDirectories;
}

- (void)setCanChooseFiles:(BOOL)canChooseFiles {
    _canChooseFiles = canChooseFiles;
}

- (NSArray *)showModal {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:_canChooseFiles];
    [openPanel setCanChooseDirectories:_canChooseDirectories];
    [openPanel setAllowsMultipleSelection:_allowsMultipleSelection];
    if (_allowedFileTypes) {
        [openPanel setAllowedFileTypes:_allowedFileTypes];
    }
    
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
    NSInteger result = [openPanel runModal];
    if (result == NSModalResponseOK) {
        return [openPanel URLs];
    }
#else
    NSInteger result = [openPanel runModal];
    if (result == NSFileHandlingPanelOKButton) {
        NSArray *urls = [openPanel URLs];
        return urls ? urls : [NSArray array];
    }
#endif
    return nil;
}

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
- (void)showWithCompletionHandler:(SSFileDialogCompletionHandler)completionHandler {
    if (!completionHandler) {
        return;
    }
    
    // Use NSOpenPanel on macOS
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:_canChooseFiles];
    [openPanel setCanChooseDirectories:_canChooseDirectories];
    [openPanel setAllowsMultipleSelection:_allowsMultipleSelection];
    if (_allowedFileTypes) {
        [openPanel setAllowedFileTypes:_allowedFileTypes];
    }
    
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            completionHandler(SSFileDialogResultOK, [openPanel URLs]);
        } else {
            completionHandler(SSFileDialogResultCancel, [NSArray array]);
        }
    }];
}
#endif

@end
