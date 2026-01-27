#include <Foundation/NSString.h>
@interface NSFramework_SmallStep : NSObject
+ (NSString *)frameworkVersion;
+ (NSString *const*)frameworkClasses;
@end
@implementation NSFramework_SmallStep
+ (NSString *)frameworkVersion { return @"0"; }
static NSString *allClasses[] = {@"SSApplicationMenu", @"SSConcurrency", @"SSFileDialog", @"SSFileSystem", @"SSPlatform", @"SSWindowStyle", @"SSLinuxPlatform", NULL};
+ (NSString *const*)frameworkClasses { return allClasses; }
@end
