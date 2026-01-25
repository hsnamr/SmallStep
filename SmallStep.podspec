Pod::Spec.new do |spec|
  spec.name         = "SmallStep"
  spec.version      = "1.0.0"
  spec.summary      = "Cross-platform abstraction layer for macOS, iOS, and Linux"
  spec.description  = <<-DESC
    SmallStep provides a unified API for common platform-specific operations,
    allowing you to write code once and run it on multiple platforms.
  DESC

  spec.homepage     = "https://github.com/yourusername/SmallStep"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Your Name" => "your.email@example.com" }

  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.13"

  spec.source       = { :git => "https://github.com/yourusername/SmallStep.git", :tag => "#{spec.version}" }

  spec.source_files = "SmallStep/Core/**/*.{h,m}", "SmallStep/Platform/**/*.{h,m}"
  spec.public_header_files = "SmallStep/Core/*.h", "SmallStep/Platform/**/*.h"
  
  spec.frameworks = "Foundation"
  spec.requires_arc = true
end
