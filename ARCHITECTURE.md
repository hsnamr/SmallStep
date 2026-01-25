# SmallStep Architecture

## Overview

SmallStep is a cross-platform abstraction layer designed to provide a unified API for common platform-specific operations across macOS, iOS, and Linux (GNUStep).

## Design Goals

1. **Unified API**: Same interface across all platforms
2. **Platform Awareness**: Automatically adapts to platform capabilities
3. **Standards Compliance**: Follows platform conventions (XDG on Linux, Cocoa on Apple)
4. **Minimal Dependencies**: Only Foundation framework required
5. **Lightweight**: Small footprint, fast performance

## Architecture

```
SmallStep/
├── Core/                          # Core platform abstraction
│   ├── SSPlatform.h/m            # Platform detection
│   ├── SSFileSystem.h/m          # File system operations
│   └── SmallStep.h                # Main framework header
└── Platform/                      # Platform-specific implementations
    ├── macOS/
    │   └── SSMacOSPlatform.h/m   # macOS-specific utilities
    ├── iOS/
    │   └── SSiOSPlatform.h/m     # iOS-specific utilities
    └── Linux/
        └── SSLinuxPlatform.h/m    # Linux/GNUStep-specific utilities
```

## Core Components

### SSPlatform

Platform detection and information:
- Runtime platform detection
- Platform name and version
- Platform-specific checks

### SSFileSystem

Unified file system operations:
- Documents directory (platform-appropriate)
- Cache directory (XDG-compliant on Linux)
- Application support directory
- File operations (read, write, delete, list)

### Platform-Specific Modules

Each platform has its own module for platform-specific features:
- **macOS**: Sandbox detection, AppKit-specific paths
- **iOS**: App extension detection, shared containers
- **Linux**: XDG Base Directory support

## Platform-Specific Behavior

### macOS/iOS
- Uses standard Cocoa directory APIs
- `NSSearchPathForDirectoriesInDomains` for standard directories
- Application Support directory includes bundle identifier

### Linux (GNUStep)
- Respects XDG Base Directory Specification
- Falls back to standard locations if XDG variables not set
- Creates directories if they don't exist

## Usage Pattern

```objc
// 1. Detect platform
if ([SSPlatform isMacOS]) {
    // macOS-specific code
}

// 2. Use unified API
SSFileSystem *fs = [SSFileSystem sharedFileSystem];
NSString *docs = [fs documentsDirectory];

// 3. Access platform-specific features when needed
#if TARGET_OS_MAC && !TARGET_OS_IPHONE
BOOL sandboxed = [SSMacOSPlatform isSandboxed];
#endif
```

## Extension Points

SmallStep is designed to be extended:

1. **New Platforms**: Add platform detection and implementation
2. **New Features**: Add new unified APIs in Core/
3. **Platform-Specific**: Add platform modules as needed

## Build System

- **macOS/iOS**: Framework (Xcode or CocoaPods)
- **Linux**: Library (GNUStep makefiles)

## Testing

Platform-specific code is conditionally compiled, allowing:
- Single codebase for all platforms
- Platform-specific optimizations
- Easy testing on each platform
