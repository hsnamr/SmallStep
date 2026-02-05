# Changelog

All notable changes to SmallStep will be documented in this file.

## [Unreleased]

### Added
- **NSView+SSTag** (GNUstep only): Category providing `-setTag:`, `-tag`, and `-viewWithTag:` for `NSView` via associated objects, so apps (e.g. SmallMarkdown, SmallBarcoder) can use `[view setTag: N]` and `[view viewWithTag: N]` without `respondsToSelector:` checks. On macOS these methods exist natively; the category is compiled only when `!defined(__APPLE__)`.

## [1.0.0] - 2026-01-26

### Added
- Initial release
- Platform detection (macOS, iOS, Linux)
- Cross-platform file system operations
- Platform-specific utilities for macOS, iOS, and Linux
- XDG Base Directory support for Linux
- Cocoa directory support for macOS/iOS

### Features
- `SSPlatform`: Platform detection and information
- `SSFileSystem`: Unified file system API
- `SSMacOSPlatform`: macOS-specific utilities
- `SSiOSPlatform`: iOS-specific utilities
- `SSLinuxPlatform`: Linux/GNUStep-specific utilities

### Documentation
- README with usage examples
- GNUmakefile for Linux/GNUStep builds
- CocoaPods podspec for iOS/macOS
