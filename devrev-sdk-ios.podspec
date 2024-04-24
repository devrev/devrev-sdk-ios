Pod::Spec.new do |spec|
  spec.name                   = "ios-sdk-test"
  spec.version                = "0.9.2"
  spec.summary                = "A test podspec for the DevRev iOS SDK"
  spec.description            = <<-DESC
								  A DevRev iOS SDK podspec that is used for internal testing purposes.
								DESC
  spec.homepage               = "https://devrev.ai"
  spec.license                = { type: "Apache 2.0", file: "LICENSE" }
  spec.author                 = { "DevRev" => "svit.zebec@devrev.ai" }
  spec.platform               = :ios, "13.0"
  spec.source                 = { http: "https://github.com/devrev/ios-sdk-test/releases/download/v0.9.2/DevRevSDK.xcframework.zip" }
  spec.vendored_frameworks    = "DevRevSDK.xcframework"
end
