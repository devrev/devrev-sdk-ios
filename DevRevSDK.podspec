Pod::Spec.new do |spec|
  spec.name = "DevRevSDK"
  spec.version = "2.2.1"
  spec.summary = "DevRev SDK, used for integrating DevRev services into your iOS app."
  spec.homepage = "https://devrev.ai"
  spec.license = "Apache 2.0"
  spec.author = { "DevRev" => "support@devrev.ai" }
  spec.platform = :ios, "15.0"
  spec.source = {
    http: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.1/DevRevSDK.xcframework.zip",
    type: :zip,
    headers: [
      "Accept: application/octet-stream",
    ],
 }
  spec.vendored_frameworks = "DevRevSDK.xcframework"
end
