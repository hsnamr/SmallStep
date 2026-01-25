# SmallStep

A cross-platform abstraction layer for Objective-C applications targeting macOS, iOS, and Linux (GNUStep).

## Overview

SmallStep provides a unified API for common platform-specific operations, allowing you to write code once and run it on multiple platforms. It abstracts away platform differences while maintaining access to platform-specific features when needed.

## Supported Platforms

- **macOS** (Cocoa/AppKit)
- **iOS** (UIKit)
- **Linux** (GNUStep)

## Features

### Platform Detection
- Detect current platform at runtime
- Platform-specific utilities and helpers

### File System Operations
- Unified file system API across all platforms
- Platform-appropriate directory handling:
  - macOS/iOS: Uses standard Cocoa directories
  - Linux: Respects XDG Base Directory Specification
- Cross-platform file operations

## Installation

### As a Framework (macOS/iOS)

1. Add SmallStep to your Xcode project
2. Link against the SmallStep framework
3. Import: `#import <SmallStep/SmallStep.h>`

### As a Library (Linux/GNUStep)

```bash
cd SmallStep
make
sudo make install
```

Then in your GNUmakefile:
```makefile
include $(GNUSTEP_MAKEFILES)/common.make
TOOL_NAME = YourApp
YourApp_OBJC_FILES = ...
YourApp_LIBRARIES_DEPEND_UPON = -lSmallStep
include $(GNUSTEP_MAKEFILES)/tool.make
```

## Usage

### Platform Detection

```objc
#import <SmallStep/SmallStep.h>

// Check platform
if ([SSPlatform isMacOS]) {
    NSLog(@"Running on macOS");
} else if ([SSPlatform isiOS]) {
    NSLog(@"Running on iOS");
} else if ([SSPlatform isLinux]) {
    NSLog(@"Running on Linux");
}

// Get platform info
NSString *platformName = [SSPlatform platformName];
NSString *version = [SSPlatform platformVersion];
```

### File System Operations

```objc
#import <SmallStep/SmallStep.h>

SSFileSystem *fileSystem = [SSFileSystem sharedFileSystem];

// Get directories
NSString *documentsDir = [fileSystem documentsDirectory];
NSString *cacheDir = [fileSystem cacheDirectory];
NSString *appSupportDir = [fileSystem applicationSupportDirectory];

// File operations
BOOL exists = [fileSystem fileExistsAtPath:@"/path/to/file"];
NSData *data = [fileSystem readFileAtPath:@"/path/to/file" error:&error];
BOOL success = [fileSystem writeString:@"Hello" toPath:@"/path/to/file" error:&error];
```

### Platform-Specific Features

#### macOS

```objc
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <SmallStep/SSMacOSPlatform.h>

BOOL sandboxed = [SSMacOSPlatform isSandboxed];
NSString *appSupport = [SSMacOSPlatform macOSApplicationSupportPath];
#endif
```

#### iOS

```objc
#if TARGET_OS_IPHONE
#import <SmallStep/SSiOSPlatform.h>

BOOL isExtension = [SSiOSPlatform isAppExtension];
NSString *docsDir = [SSiOSPlatform iOSDocumentsDirectory];
#endif
```

#### Linux

```objc
#if defined(__GNUSTEP__) || defined(__linux__)
#import <SmallStep/SSLinuxPlatform.h>

NSString *xdgData = [SSLinuxPlatform xdgDataHome];
NSString *xdgConfig = [SSLinuxPlatform xdgConfigHome];
NSString *xdgCache = [SSLinuxPlatform xdgCacheHome];
#endif
```

## Architecture

```
SmallStep/
├── Core/                    # Core platform abstraction
│   ├── SSPlatform.h/m       # Platform detection
│   ├── SSFileSystem.h/m     # File system operations
│   └── SmallStep.h          # Main header
└── Platform/                # Platform-specific implementations
    ├── macOS/               # macOS-specific code
    ├── iOS/                  # iOS-specific code
    └── Linux/                # Linux/GNUStep-specific code
```

## Design Principles

1. **Unified API**: Same interface across all platforms
2. **Platform Awareness**: Detect and adapt to platform capabilities
3. **Standards Compliance**: Follow platform conventions (XDG on Linux, Cocoa on Apple platforms)
4. **Minimal Dependencies**: Only Foundation framework required
5. **Lightweight**: Small footprint, fast performance

## Building

### macOS/iOS (Xcode)

1. Open `SmallStep.xcodeproj` (create if needed)
2. Select target platform
3. Build framework

### Linux (GNUStep)

```bash
make
```

## License

See LICENSE file for details.

## Contributing

When adding platform-specific features:
1. Add core abstraction in `Core/`
2. Implement platform-specific code in `Platform/[platform]/`
3. Update documentation
4. Add tests if applicable
