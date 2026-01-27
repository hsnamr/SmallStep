//
//  SSFileDialog.m
//  SmallStep
//
//  Cross-platform file dialog implementation
//

#import "SSFileDialog.h"
#import "SSPlatform.h"
#import <objc/runtime.h>

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#elif TARGET_OS_WIN32
#import <UIKit/UIKit.h>
#elif defined(__GNUSTEP__) || defined(__linux__)
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
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
    if (_isSaveDialog) {
        // Use NSSavePanel for save dialogs
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setCanCreateDirectories:_canCreateDirectories];
        if (_allowedFileTypes) {
            [savePanel setAllowedFileTypes:_allowedFileTypes];
        }
        
        NSInteger result = [savePanel runModal];
        if (result == NSModalResponseOK) {
            NSURL *url = [savePanel URL];
            return url ? [NSArray arrayWithObject:url] : nil;
        }
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
        
        NSInteger result = [openPanel runModal];
        if (result == NSModalResponseOK) {
            return [openPanel URLs];
        }
        return nil;
    }
#elif TARGET_OS_IPHONE
    // iOS: showModal is not supported, use showWithCompletionHandler instead
    // Return nil to indicate modal is not available
    return nil;
#elif TARGET_OS_WIN32
    // Windows: showModal is not supported, use showWithCompletionHandler instead
    // Return nil to indicate modal is not available
    return nil;
#elif defined(__GNUSTEP__) || defined(__linux__)
    // Linux/GNUstep: Import AppKit for NSSavePanel/NSOpenPanel
    #ifndef GNUSTEP
    #import <AppKit/AppKit.h>
    #endif
    
    if (_isSaveDialog) {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setCanCreateDirectories:_canCreateDirectories];
        if (_allowedFileTypes) {
            [savePanel setAllowedFileTypes:_allowedFileTypes];
        }
        
        NSInteger result = [savePanel runModal];
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = [savePanel URL];
            return url ? [NSArray arrayWithObject:url] : nil;
        }
        return nil;
    } else {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseFiles:_canChooseFiles];
        [openPanel setCanChooseDirectories:_canChooseDirectories];
        [openPanel setAllowsMultipleSelection:_allowsMultipleSelection];
        if (_allowedFileTypes) {
            [openPanel setAllowedFileTypes:_allowedFileTypes];
        }
        
        NSInteger result = [openPanel runModal];
        if (result == NSFileHandlingPanelOKButton) {
            NSArray *urls = [openPanel URLs];
            return urls ? urls : [NSArray array];
        }
        return nil;
    }
#else
    // Other platforms: not supported
    return nil;
#endif
}

#if __has_feature(blocks) || (TARGET_OS_IPHONE && __clang__)
- (void)showWithCompletionHandler:(SSFileDialogCompletionHandler)completionHandler {
    if (!completionHandler) {
        return;
    }
    
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
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
#elif TARGET_OS_IPHONE
    // iOS: Use UIImagePickerController for photos, UIDocumentPickerViewController for Files
    UIViewController *rootViewController = nil;
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (window.isKeyWindow) {
            keyWindow = window;
            rootViewController = window.rootViewController;
            break;
        }
    }
    
    if (!rootViewController) {
        completionHandler(SSFileDialogResultCancel, [NSArray array]);
        return;
    }
    
    // For image files, use PHPickerViewController (iOS 14+) or UIImagePickerController
    BOOL isImageType = NO;
    if (_allowedFileTypes) {
        for (NSString *type in _allowedFileTypes) {
            if ([type isEqualToString:@"jpg"] || [type isEqualToString:@"jpeg"] || 
                [type isEqualToString:@"png"] || [type isEqualToString:@"tiff"] || 
                [type isEqualToString:@"tif"]) {
                isImageType = YES;
                break;
            }
        }
    }
    
    if (isImageType && !_isSaveDialog) {
        // Use PHPickerViewController for photos (iOS 14+)
        if (@available(iOS 14, *)) {
            PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
            config.filter = [PHPickerFilter imagesFilter];
            config.selectionLimit = _allowsMultipleSelection ? 0 : 1;
            
            PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
            picker.delegate = self;
            
            // Store completion handler and self reference
            objc_setAssociatedObject(picker, @"completionHandler", completionHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(picker, @"fileDialog", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            [rootViewController presentViewController:picker animated:YES completion:nil];
        } else {
            // Fallback to UIImagePickerController for iOS < 14
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = NO;
            
            objc_setAssociatedObject(picker, @"completionHandler", completionHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(picker, @"fileDialog", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            [rootViewController presentViewController:picker animated:YES completion:nil];
        }
    } else {
        // Use UIDocumentPickerViewController for Files app
        NSArray *documentTypes = _allowedFileTypes ? _allowedFileTypes : @[@"public.data"];
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeImport];
        picker.delegate = self;
        picker.allowsMultipleSelection = _allowsMultipleSelection;
        
        objc_setAssociatedObject(picker, @"completionHandler", completionHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(picker, @"fileDialog", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [rootViewController presentViewController:picker animated:YES completion:nil];
    }
#elif TARGET_OS_WIN32
    // Windows: Use WinObjC file picker
    // For now, return cancel - Windows file picker implementation would go here
    completionHandler(SSFileDialogResultCancel, [NSArray array]);
#else
    // Linux/GNUstep: Use NSOpenPanel/NSSavePanel
    if (_isSaveDialog) {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setCanCreateDirectories:_canCreateDirectories];
        if (_allowedFileTypes) {
            [savePanel setAllowedFileTypes:_allowedFileTypes];
        }
        
        // GNUstep doesn't support blocks, use showModal instead
        NSArray *result = [self showModal];
        if (result && result.count > 0) {
            completionHandler(SSFileDialogResultOK, result);
        } else {
            completionHandler(SSFileDialogResultCancel, [NSArray array]);
        }
    } else {
        // GNUstep doesn't support blocks, use showModal instead
        NSArray *result = [self showModal];
        if (result && result.count > 0) {
            completionHandler(SSFileDialogResultOK, result);
        } else {
            completionHandler(SSFileDialogResultCancel, [NSArray array]);
        }
    }
#endif
}
#endif

#if TARGET_OS_IPHONE && (__has_feature(blocks) || __clang__)
// iOS delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    SSFileDialogCompletionHandler handler = objc_getAssociatedObject(picker, @"completionHandler");
    [picker dismissViewControllerAnimated:YES completion:^{
        if (handler) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (image) {
                // Save to temporary location and return URL
                NSData *imageData = UIImagePNGRepresentation(image);
                NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"picked_image.png"];
                [imageData writeToFile:tempPath atomically:YES];
                NSURL *url = [NSURL fileURLWithPath:tempPath];
                handler(SSFileDialogResultOK, url ? [NSArray arrayWithObject:url] : [NSArray array]);
            } else {
                handler(SSFileDialogResultCancel, [NSArray array]);
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    SSFileDialogCompletionHandler handler = objc_getAssociatedObject(picker, @"completionHandler");
    [picker dismissViewControllerAnimated:YES completion:^{
        if (handler) {
            handler(SSFileDialogResultCancel, [NSArray array]);
        }
    }];
}

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)) {
    SSFileDialogCompletionHandler handler = objc_getAssociatedObject(picker, @"completionHandler");
    [picker dismissViewControllerAnimated:YES completion:^{
        if (handler && results.count > 0) {
            NSMutableArray *urls = [NSMutableArray array];
            dispatch_group_t group = dispatch_group_create();
            
            NSInteger index = 0;
            for (PHPickerResult *result in results) {
                dispatch_group_enter(group);
                NSInteger currentIndex = index++;
                [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading> _Nullable object, NSError * _Nullable error) {
                    if ([object isKindOfClass:[UIImage class]]) {
                        UIImage *image = (UIImage *)object;
                        NSData *imageData = UIImagePNGRepresentation(image);
                        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"picked_image_%ld.png", (long)currentIndex]];
                        [imageData writeToFile:tempPath atomically:YES];
                        NSURL *url = [NSURL fileURLWithPath:tempPath];
                        if (url) {
                            @synchronized(urls) {
                                [urls addObject:url];
                            }
                        }
                    }
                    dispatch_group_leave(group);
                }];
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                handler(urls.count > 0 ? SSFileDialogResultOK : SSFileDialogResultCancel, urls);
            });
        } else if (handler) {
            handler(SSFileDialogResultCancel, [NSArray array]);
        }
    }];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    SSFileDialogCompletionHandler handler = objc_getAssociatedObject(controller, @"completionHandler");
    [controller dismissViewControllerAnimated:YES completion:^{
        if (handler) {
            handler(SSFileDialogResultOK, urls ? urls : [NSArray array]);
        }
    }];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    SSFileDialogCompletionHandler handler = objc_getAssociatedObject(controller, @"completionHandler");
    [controller dismissViewControllerAnimated:YES completion:^{
        if (handler) {
            handler(SSFileDialogResultCancel, [NSArray array]);
        }
    }];
}
#endif

@end
