Pod::Spec.new do |spec|
  spec.name                   = "devrev-sdk-ios"
  spec.version                = "0.9.2"
  spec.summary                = "A podspec for the DevRev iOS SDK"
  spec.description            = <<-DESC
								  A podspec that is used for the main release of the DevRev iOS SDK.
								DESC
  spec.homepage               = "https://devrev.ai"
  spec.license                = { type: "Apache 2.0", file: "LICENSE" }
  spec.author                 = { "DevRev" => "svit.zebec@devrev.ai" }
  spec.platform               = :ios, "13.0"
  spec.source                 = { http: "https://github.com/devrev/devrev-sdk-ios/releases/download/v0.9.2/DevRevSDK.xcframework.zip" }
  spec.vendored_frameworks    = "DevRevSDK.xcframework"
end
