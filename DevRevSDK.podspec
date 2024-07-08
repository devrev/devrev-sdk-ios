Pod::Spec.new do |spec|
  spec.name                   = "DevRevSDK"
  spec.version                = "0.9.3"
  spec.summary                = "DevRev SDK, used for integrating DevRev services into your iOS app."
  spec.homepage               = "https://devrev.ai"
  spec.license                = { type: "Apache 2.0", file: "LICENSE" }
  spec.author                 = { "DevRev" => "support@devrev.ai" }
  spec.platform               = :ios, "13.0"
  spec.source                 = { http: "https://github.com/devrev/devrev-sdk-ios/releases/download/v0.9.3/DevRevSDK.xcframework.zip" }
  spec.vendored_frameworks    = "DevRevSDK.xcframework"
end
