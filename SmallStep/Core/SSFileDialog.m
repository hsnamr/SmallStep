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
    SSFileDialog *dialog = [[self alloc] init];
    dialog->_isSaveDialog = NO;
    return dialog;
}

+ (instancetype)saveDialog {
    SSFileDialog *dialog = [[self alloc] init];
    dialog->_isSaveDialog = YES;
    dialog->_canChooseFiles = YES;
    dialog->_canChooseDirectories = NO;
    dialog->_allowsMultipleSelection = NO;
    return dialog;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allowsMultipleSelection = NO;
        _canChooseDirectories = NO;
        _canChooseFiles = YES;
        _canCreateDirectories = NO;
        _allowedFileTypes = nil;
        _isSaveDialog = NO;
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

- (void)setCanCreateDirectories:(BOOL)canCreateDirectories {
    _canCreateDirectories = canCreateDirectories;
}

- (NSArray *)showModal {
    if (_isSaveDialog) {
        // Use NSSavePanel for save dialogs
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setCanCreateDirectories:_canCreateDirectories];
        if (_allowedFileTypes) {
            [savePanel setAllowedFileTypes:_allowedFileTypes];
        }
        
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
        NSInteger result = [savePanel runModal];
        if (result == NSModalResponseOK) {
            NSURL *url = [savePanel URL];
            return url ? [NSArray arrayWithObject:url] : nil;
        }
#else
        NSInteger result = [savePanel runModal];
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = [savePanel URL];
            return url ? [NSArray arrayWithObject:url] : nil;
        }
#endif
        return nil;
    } else {
        // Use NSOpenPanel for open dialogs
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
}

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
- (void)showWithCompletionHandler:(SSFileDialogCompletionHandler)completionHandler {
    if (!completionHandler) {
        return;
    }
    
    if (_isSaveDialog) {
        // Use NSSavePanel for save dialogs
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setCanCreateDirectories:_canCreateDirectories];
        if (_allowedFileTypes) {
            [savePanel setAllowedFileTypes:_allowedFileTypes];
        }
        
        [savePanel beginWithCompletionHandler:^(NSInteger result) {
            if (result == NSModalResponseOK) {
                NSURL *url = [savePanel URL];
                completionHandler(SSFileDialogResultOK, url ? [NSArray arrayWithObject:url] : [NSArray array]);
            } else {
                completionHandler(SSFileDialogResultCancel, [NSArray array]);
            }
        }];
    } else {
        // Use NSOpenPanel for open dialogs
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
}
#endif

@end
