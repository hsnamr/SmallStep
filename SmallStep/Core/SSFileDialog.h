//
//  SSFileDialog.h
//  SmallStep
//
//  Cross-platform file dialog abstraction
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

/// File dialog result codes
typedef NS_ENUM(NSInteger, SSFileDialogResult) {
    SSFileDialogResultOK = 0,
    SSFileDialogResultCancel = 1
};

/// Cross-platform file dialog abstraction
@interface SSFileDialog : NSObject {
    NSArray *_allowedFileTypes;
    BOOL _allowsMultipleSelection;
    BOOL _canChooseDirectories;
    BOOL _canChooseFiles;
}

/// Create a file open dialog
+ (instancetype)openDialog;

/// Set allowed file types
/// @param fileTypes Array of file extensions (e.g., @[@"jpg", @"png"])
- (void)setAllowedFileTypes:(NSArray *)fileTypes;

/// Set whether multiple files can be selected
/// @param allowsMultiple Whether to allow multiple selection
- (void)setAllowsMultipleSelection:(BOOL)allowsMultiple;

/// Set whether directories can be selected
/// @param canChooseDirectories Whether directories can be chosen
- (void)setCanChooseDirectories:(BOOL)canChooseDirectories;

/// Set whether files can be selected
/// @param canChooseFiles Whether files can be chosen
- (void)setCanChooseFiles:(BOOL)canChooseFiles;

/// Show the dialog modally (synchronous)
/// @return Array of selected URLs, or nil if cancelled
- (NSArray *)showModal;

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
/// File dialog completion handler (macOS only)
typedef void (^SSFileDialogCompletionHandler)(SSFileDialogResult result, NSArray *urls);

/// Show the dialog and call completion handler (macOS only)
/// @param completionHandler Block called when dialog is dismissed
- (void)showWithCompletionHandler:(SSFileDialogCompletionHandler)completionHandler;
#endif

@end

NS_ASSUME_NONNULL_END
