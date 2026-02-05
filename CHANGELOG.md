# Changelog

All notable changes to SmallStep will be documented in this file.

## [Unreleased]

### Removed
- **NSView+SSTag**: Removed GNUstep workaround; `NSView` now implements `-setTag:`, `-tag`, and `-viewWithTag:` natively on supported platforms.

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
