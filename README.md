# DevRev SDK for iOS
DevRev SDK, used for integrating DevRev services into your iOS app.

## Table of contents
- [DevRev SDK for iOS](#devrev-sdk-for-ios)
	- [Table of contents](#table-of-contents)
	- [Quickstart](#quickstart)
		- [Requirements](#requirements)
		- [Integration](#integration)
			- [Swift Package Manager (Recommended)](#swift-package-manager-recommended)
			- [CocoaPods](#cocoapods)
		- [Set up the DevRev SDK](#set-up-the-devrev-sdk)
				- [UIKit apps](#uikit-apps)
				- [SwiftUI apps](#swiftui-apps)
	- [Features](#features)
		- [Identification](#identification)
			- [Anonymous identification](#anonymous-identification)
			- [Unverified identification](#unverified-identification)
			- [Verified identification](#verified-identification)
				- [Generate an AAT](#generate-an-aat)
				- [Exchange your AAT for a session token](#exchange-your-aat-for-a-session-token)
				- [Identifying the verified user](#identifying-the-verified-user)
			- [Updating the user](#updating-the-user)
			- [Logout](#logout)
			- [Examples](#examples)
			- [Identity model](#identity-model)
				- [Properties](#properties)
					- [UserTraits](#usertraits)
					- [OrganizationTraits](#organizationtraits)
					- [AccountTraits](#accounttraits)
		- [PLuG support chat](#plug-support-chat)
			- [UIKit](#uikit)
				- [Examples](#examples-1)
			- [SwiftUI](#swiftui)
			- [Creating a new conversation](#creating-a-new-conversation)
			- [New conversation closure](#new-conversation-closure)
				- [Example](#example)
		- [In-app link handling](#in-app-link-handling)
		- [Dynamic theme configuration](#dynamic-theme-configuration)
		- [Analytics](#analytics)
			- [Example](#example-1)
		- [Session analytics](#session-analytics)
			- [Opting-in or out](#opting-in-or-out)
			- [Session recording](#session-recording)
			- [Session properties](#session-properties)
			- [Masking sensitive data](#masking-sensitive-data)
			- [Custom masking provider](#custom-masking-provider)
				- [Example](#example-2)
			- [Timers](#timers)
				- [Example](#example-3)
			- [Screen tracking](#screen-tracking)
				- [Example](#example-4)
		- [Push notifications](#push-notifications)
			- [Configuration](#configuration)
			- [Register for push notifications](#register-for-push-notifications)
				- [Example](#example-5)
			- [Unregister from push notifications](#unregister-from-push-notifications)
				- [Example](#example-6)
			- [Handle push notifications](#handle-push-notifications)
				- [Example](#example-7)
	- [Sample app](#sample-app)
	- [Troubleshooting](#troubleshooting)
	- [Migration guide](#migration-guide)

## Quickstart
### Requirements
- Xcode 16.0 or later (latest stable version available on the App Store).
- Swift 5.9 or later.
- Set the minimum deployment target for your iOS application as iOS 15.

### Integration
The DevRev SDK can be integrated using either Swift Package Manager (SPM) or CocoaPods.

> [!CAUTION]
> We recommend integrating the DevRev SDK using Swift Package Manager. CocoaPods is in [maintenance mode](https://blog.cocoapods.org/CocoaPods-Support-Plans/) since August 2024 and will be [deprecated in the future](https://blog.cocoapods.org/CocoaPods-Specs-Repo/).

#### Swift Package Manager (Recommended)
You can integrate the DevRev SDK in your project as a Swift Package Manager (SPM) package.

To integrate the DevRev SDK into your project using SPM:

1. Open your project in Xcode and navigate to the **Add Package Dependency**.
2. Enter the DevRev SDK URL under **Enter Package URL**:
	- For HTTPS: https://github.com/devrev/devrev-sdk-ios
	- For SSH: `git@github.com:devrev/devrev-sdk-ios.git`
3. In the **Build Phases** section of your app target, locate the **Link Binary With Libraries** phase and confirm that `DevRevSDK` is linked. If not, add it by clicking **+** and selecting `DevRevSDK` from the list.

Now you should be able to import and use the DevRev SDK in your project.

#### CocoaPods
To integrate the DevRev SDK using CocoaPods:

1. Add the following to your `Podfile`:
	```ruby
   pod 'DevRevSDK', '~> 1.0.0'
    ```

2. Run `pod install` in your project directory.

This will install the DevRev SDK in your project, making it ready for use.

### Set up the DevRev SDK
1. Open the DevRev web app at [https://app.devrev.ai](https://app.devrev.ai) and go to the **Settings** page.
2. Under **PLuG settings** copy the value under **Your unique App ID**.
3. After obtaining the credentials, you can configure the DevRev SDK in your app.

The SDK will be ready for use once you execute the following configuration method.
```swift
DevRev.configure(appID:)
```

Use this property to check whether the DevRev SDK has been configured:
```swift
await DevRev.isConfigured
```

For example:

```swift
DevRev.configure(appID: "abcdefg12345")
```

##### UIKit apps
Configure the SDK in the `AppDelegate.application(_:didFinishLaunchingWithOptions:)` method.

##### SwiftUI apps
Depending on your app's architecture, configure the SDK at the app's entry point or initial view.

## Features
### Identification
To access certain features of the DevRev SDK, user identification is required.

The identification function should be placed appropriately in your app after the user logs in. If you have the user information available at app launch, call the function after the `DevRev.configure(appID:)` method.

> [!IMPORTANT]
> If you haven't previously identified the user, the DevRev SDK will automatically create an anonymous user for you immediately after the SDK is configured.

> [!IMPORTANT]
> The `Identity` structure allows for custom fields in the user, organization, and account traits. These fields must be configured through the DevRev app before they can be utilized. For more information, refer to [Object customization](https://devrev.ai/docs/product/object-customization).

#### Anonymous identification
The anonymous identification method allows you to create an anonymous user with an optional user identifier, ensuring that no other data is stored or associated with the user.

```swift
DevRev.identifyAnonymousUser(userID:)
```

#### Unverified identification
The unverified identification method identifies users with a unique identifier, but it does not verify their identity with the DevRev backend.

```swift
DevRev.identifyUnverifiedUser(_:)
```

The function accepts the `DevRev.Identity` structure, with the user identifier (`userID`) as the only required property, all other properties are optional.

#### Verified identification
The verified identification method is used to identify users with an identifier unique to your system within the DevRev platform. The verification is done through a token exchange process between you and the DevRev backend.

The steps to identify a verified user are as follows:
1. Generate an AAT for your system (preferably through your backend).
2. Exchange your AAT for a session token for each user of your system.
3. Pass the user identifier and the exchanged session token to the `DevRev.identifyVerifiedUser(_:sessionToken:)` method.

> [!CAUTION]
> For security reasons we **strongly recommend** that the token exchange is executed on your backend to prevent exposing your application access token (AAT).

##### Generate an AAT
1. Open the DevRev web app at [https://app.devrev.ai](https://app.devrev.ai) and go to the **Settings** page.
2. Open the **PLuG Tokens** page.
3. Under the **Application access tokens** panel, click **New token** and copy the token that's displayed.

> [!IMPORTANT]
> Ensure that you copy the generated application access token, as you cannot view it again.

##### Exchange your AAT for a session token
In order to proceed with identifying the user, you need to exchange your AAT for a session token. This step will help you identify a user of your own system within the DevRev platform.

Here is a simple example of an API request to the DevRev backend to exchange your AAT for a session token:
> [!CAUTION]
> Make sure that you replace the `<AAT>` and `<YOUR_USER_ID>` with the actual values.
```bash
curl \
--location 'https://api.devrev.ai/auth-tokens.create' \
--header 'accept: application/json, text/plain, */*' \
--header 'content-type: application/json' \
--header 'authorization: <AAT>' \
--data '{
  "rev_info": {
    "user_ref": "<YOUR_USER_ID>"
  }
}'
```

The response of the API call will contain a session token that you can use with the verified identification method in your app.

> [!NOTE]
> As a good practice, **your** app should retrieve the exchanged session token from **your** backend at app launch or any relevant app lifecycle event.

##### Identifying the verified user
Pass the user identifier and the exchanged session token to the verified identification method:
```swift
DevRev.identifyVerifiedUser(_:sessionToken:)
```

#### Updating the user
You can update the user's information using the following method:

```swift
DevRev.updateUser(_:)
```

The function accepts the `DevRev.Identity` structure.

> [!IMPORTANT]
> The `userID` property can *not* be updated.

Use this property to check whether the user is identified in the current session:
```swift
await DevRev.isUserIdentified
```

#### Logout
You can perform a logout of the current user by calling the following method:

```swift
DevRev.logout(deviceID:)
```

The user will be logged out by clearing their credentials, as well as unregistering the device from receiving push notifications, and stopping the session recording.

#### Examples

> [!NOTE]
The identification functions are asynchronous, make sure that you wrap them in a `Task` when calling them from synchronous contexts.

```swift
// Identify an anonymous user without a user identifier.
await DevRev.identifyAnonymousUser()

// Identify an unverified user using their email address as the user identifier.
await DevRev.identifyUnverifiedUser(Identity(userID: "foo@example.org"))

// Identify a verified user using their email address as the user identifier.
await DevRev.identifyVerifiedUser("foo@example.org", sessionToken: "bar-1337")
// Update the user's information.
await DevRev.updateUser(Identity(organizationID: "foo-bar-1337"))
```

#### Identity model
The `Identity` class is used to provide user, organization, and account information when identifying users or updating their details. This class is used primarily with the `identifyUnverifiedUser(_:)` and `updateUser(_:)` methods.

##### Properties
The `Identity` class contains the following properties:

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `userID` | `String` | ✅ | A unique identifier for the user |
| `organizationID` | `String?` | ❌ | An identifier for the user's organization |
| `accountID` | `String?` | ❌ | An identifier for the user's account |
| `userTraits` | `UserTraits?` | ❌ | Additional information about the user |
| `organizationTraits` | `OrganizationTraits?` | ❌ | Additional information about the organization |
| `accountTraits` | `AccountTraits?` | ❌ | Additional information about the account |

> [!NOTE]
> The custom fields properties defined as part of the user, organization and account traits, must be configured in the DevRev web app **before** they can be used. See [Object customization](https://devrev.ai/docs/product/object-customization) for more information.

###### UserTraits
The `UserTraits` class contains detailed information about the user:

> [!NOTE]
> All properties in `UserTraits` are optional.

| Property | Type | Description |
|----------|------|-------------|
| `displayName` | `String?` | The displayed name of the user |
| `email` | `String?` | The user's email address |
| `fullName` | `String?` | The user's full name |
| `userDescription` | `String?` | A description of the user |
| `phoneNumbers` | `[String]?` | Array of the user's phone numbers |
| `customFields` | `[String: Any]?` | Dictionary of custom fields configured in DevRev |

###### OrganizationTraits
The `OrganizationTraits` class contains detailed information about the organization:

> [!NOTE]
> All properties in `OrganizationTraits` are optional.

| Property | Type | Description |
|----------|------|-------------|
| `displayName` | `String?` | The displayed name of the organization |
| `domain` | `String?` | The organization's domain |
| `organizationDescription` | `String?` | A description of the organization |
| `phoneNumbers` | `[String]?` | Array of the organization's phone numbers |
| `tier` | `String?` | The organization's tier or plan level |
| `customFields` | `[String: Any]?` | Dictionary of custom fields configured in DevRev |

###### AccountTraits
The `AccountTraits` class contains detailed information about the account:

> [!NOTE]
> All properties in `AccountTraits` are optional.

| Property | Type | Description |
|----------|------|-------------|
| `displayName` | `String?` | The displayed name of the account |
| `domains` | `[String]?` | Array of domains associated with the account |
| `accountDescription` | `String?` | A description of the account |
| `phoneNumbers` | `[String]?` | Array of the account's phone numbers |
| `websites` | `[String]?` | Array of websites associated with the account |
| `tier` | `String?` | The account's tier or plan level |
| `customFields` | `[String: Any]?` | Dictionary of custom fields configured in DevRev |

### PLuG support chat
#### UIKit
The support chat feature can be shown as a modal screen from a specific view controller or the top-most one, or can be pushed onto a navigation stack. 

To show the support chat screen in your app, you can use the following overloaded method:
```swift
await DevRev.showSupport(from:isAnimated:)
```

- When a `UIViewController` is passed as the `from` parameter, the screen is shown modally.
- When a `UINavigationController` is passed as the `from` parameter, the screen is pushed onto the navigation stack.

If you want to display the support chat screen from the top-most view controller, use the following method:
```swift
await DevRev.showSupport(isAnimated:)
```

##### Examples
```swift
/// When set to true (default), the DevRev UI will adapt theme dynamically to the system appearance.
/// Set this flag to false to force the DevRev UI to use the default theme configured in the DevRev portal.
DevRev.prefersSystemTheme: Bool

/// Push the support chat screen to a navigation stack.
await DevRev.showSupport(from: mainNavigationController)

/// Show the support chat screen modally from a specific view controller.
await DevRev.showSupport(from: settingsViewController)

/// Show the support chat screen from the top-most view controller, without an animation.
await DevRev.showSupport(isAnimated: false)
```

#### SwiftUI
To display the support chat screen in a SwiftUI app, you can use the following view:

```swift
DevRev.supportView
```

#### Creating a new conversation
You have the ability to create a new conversation from within your app. The method will show the support chat screen and create a new conversation at the same time.

```swift
DevRev.createSupportConversation()
```

#### New conversation closure
You can receive a callback when a new conversation is created by setting the following closure:

```swift
DevRev.conversationCreatedCompletion
```

This allows your app to access the ID of the newly created conversation.

##### Example
```swift
DevRev.conversationCreatedCompletion = { conversationID in
	print("A new conversation has been created: \(conversationID).")
}
```

### In-app link handling
The DevRev SDK provides a mechanism to handle links opened from within any screen that is part of the DevRev SDK.

You can fully customize the link handling behavior by setting the specialized in-app link handler. That way you can decide what should happen when a link is opened from within the app.

```swift
DevRev.inAppLinkHandler: ((URL) -> Void)?
```

You can further customize the behavior by setting the `shouldDismissModalsOnOpenLink` boolean flag. This flag controls whether the DevRev SDK should dismiss the top-most modal screen when a link is opened.

```swift
DevRev.shouldDismissModalsOnOpenLink: Bool
```

### Dynamic theme configuration
The DevRev SDK allows you to configure the theme dynamically based on the system appearance, or use the theme configured on the DevRev portal. By default, the theme will be dynamic and follow the system appearance.

```swift
DevRev.prefersSystemTheme: Bool
```

### Analytics
The DevRev SDK allows you to send custom analytic events by using a name and a string dictionary. You can track these events using the following function:
```swift
DevRev.trackEvent(name:properties:)
```

#### Example
```swift
await DevRev.trackEvent(name: "open-message-screen", properties: ["id": "foo-bar-1337"])
```

### Session analytics
The DevRev SDK provides observability features to help you understand how your users are interacting with your app.

#### Opting-in or out
Session analytics features are opted-in by default, enabling them from the start. However, you can opt-out using the following method:
```swift
DevRev.stopAllMonitoring()
```

To opt back in, use the following method:

```swift
DevRev.resumeAllMonitoring()
```

You can check whether session monitoring has been enabled by using this property:
```swift
DevRev.isMonitoringEnabled
```

#### Session recording
You can enable session recording to capture user interactions with your app.

> [!CAUTION]
> The session recording feature is opt-out and is enabled by default.

The session recording feature includes the following methods to control the recording:
|Method|Action|
|-|-|
|`DevRev.startRecording()`|Starts the session recording.|
|`DevRev.stopRecording()`|Ends the session recording and uploads it to the portal.|
|`DevRev.pauseRecording()`|Pauses the ongoing session recording.|
|`DevRev.resumeRecording()`|Resumes a paused session recording.|
|`DevRev.processAllOnDemandSessions()`| Stops the ongoing user recording and sends all on-demand sessions along with the current recording. |

Using this property will return the status of the session recording:
```swift
DevRev.isRecording
```

To check if on-demand sessions are enabled, use:
```swift
DevRev.areOnDemandSessionsEnabled
```

#### Session properties
You can add custom properties to the session recording to help you understand the context of the session. The properties are defined as a dictionary of string values.

```swift
DevRev.addSessionProperties(_:)
```

To clear the session properties in scenarios such as user logout or when the session ends, use the following method:

```swift
DevRev.clearSessionProperties()
```

#### Masking sensitive data
To protect sensitive data, the DevRev SDK provides an auto-masking feature that masks data before sending to the server. Input views such as text fields, text views, and web views are automatically masked.

While the auto-masking feature may be sufficient for most situations, you can manually mark additional views as sensitive using the following method:

```swift
DevRev.markSensitiveViews(_:)
```

If any previously masked views need to be unmasked, you can use the following method:

```swift
DevRev.unmarkSensitiveViews(_:)
```

#### Custom masking provider
For advanced use cases, you can provide a custom masking provider to specify exactly which regions of the UI should be masked in snapshots.

You can implement your own masking logic by conforming to the `DevRev.MaskLocationProviding` protocol and setting your custom object as the masking provider. This allows you to specify explicit regions to be masked or to skip snapshots entirely.

- `DevRev.setMaskingLocationProvider(_ provider: DevRev.MaskLocationProviding)`: Sets the external view masking provider used to determine which areas of the UI should be masked for privacy during snapshots. The provider must conform to the `DevRev.MaskLocationProviding` protocol.
- `DevRev.MaskLocationProviding`: Protocol for providing explicit masking locations for UI snapshots.
- `DevRev.SnapshotMask`: Describes the regions of a snapshot to be masked.
- `DevRev.SnapshotMask.Location`: Describes a masked region.

##### Example
```swift
import Foundation
import UIKit
import DevRevSDK

class MyMaskingProvider: NSObject, DevRev.MaskLocationProviding {
    func provideSnapshotMask(_ completionHandler: @escaping (DevRev.SnapshotMask) -> Void) {
        // Example: Mask a specific region
        let region = CGRect(x: 10, y: 10, width: 100, height: 40)
        let location = DevRev.SnapshotMask.Location(location: region)
        let mask = DevRev.SnapshotMask(locations: [location], shouldSkip: false)
        completionHandler(mask)
    }
}
```

```swift
DevRev.setMaskingLocationProvider(MyMaskingProvider())
```

> [!NOTE]
> Setting a new provider will override any previously set masking location provider.

#### Timers
The DevRev SDK offers a timer mechanism to measure the time spent on specific tasks, allowing you to track events such as response time, loading time, or any other duration-based metrics.

The mechanism works using balanced start and stop methods that both accept a timer name and an optional dictionary of properties.

To start a timer, use the following method:
```swift
DevRev.startTimer(_:properties:)
```

To stop a timer, use the following method:
```swift
DevRev.endTimer(_:properties:)
```

##### Example
```swift
DevRev.startTimer("response-time", properties: ["id": "foo-bar-1337"])

// Perform the task that you want to measure.

DevRev.stopTimer("response-time", properties: ["id": "foo-bar-1337"])
```

#### Screen tracking
The DevRev SDK offers automatic screen tracking to help you understand how users navigate through your app. Although view controllers are automatically tracked, you can manually track screens using the following method:

```swift
DevRev.trackScreenName(_:)
```

##### Example
```swift
DevRev.trackScreenName("profile-screen")
```

### Push notifications
You can configure your app to receive push notifications from the DevRev SDK. The SDK is designed to handle push notifications and execute actions based on the notification's content.

The DevRev backend sends push notifications to your app to notify users about new messages in the PLuG support chat.

#### Configuration
To receive push notifications, you need to configure your DevRev organization by following the instructions in the [push notifications](https://developer.devrev.ai/public/sdks/mobile/push-notification) section.

You need to ensure that your iOS app is configured to receive push notifications. You can follow the [Apple documentation](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns) for guidance on registering your app with Apple Push Notification Service (APNs).

#### Register for push notifications
> [!IMPORTANT]
> Push notifications require that the SDK has been configured and the user has been identified (unverified and anonymous users). The user identification is required to send the push notification to the correct user.

The DevRev SDK offers a method to register your device for receiving push notifications. You can register for push notifications using the following method:

```swift
DevRev.registerDeviceToken(_:deviceID:)
```

The method requires a device identifier, which can either be an identifier unique to your system or the Apple-provided Vendor Identifier (IDFV). Typically, the token registration is called from the `AppDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` method.

##### Example
```swift
func application(
	_ application: UIApplication,
	didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
	guard
		let deviceID = UIDevice.current.identifierForVendor?.uuidString
	else {
		return
	}

	Task {
		await DevRev.registerDeviceToken(
			deviceToken,
			deviceID: deviceID
		)
	}
}
```

#### Unregister from push notifications
If your app no longer needs to receive push notifications, you can unregister the device.

Use the following method to unregister the device:

```swift
DevRev.unregisterDevice(_:)
```

This method requires the device identifier, which should be the same as the one used during registration. It is recommended to place this method after calling `UIApplication.unregisterForRemoteNotifications()` in your app.

##### Example
```swift
UIApplication.shared.unregisterForRemoteNotifications()

Task {
	guard
		let deviceID = UIDevice.current.identifierForVendor?.uuidString
	else {
		return
	}

	await DevRev.unregisterDevice(deviceID)
}
```

#### Handle push notifications
Push notifications coming to the DevRev SDK need to be handled manually. To properly handle them, implement the following method, typically in either the `UNUserNotificationCenterDelegate.userNotificationCenter(_:didReceive:)` or `UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`:

```swift
DevRev.processPushNotification(_:)
```

> [!IMPORTANT]
> For convenience, this method provides two overloads that accept `userInfo` as either `[AnyHashable: Any]` or `[String: any Sendable]` dictionary types.

##### Example
```swift
func userNotificationCenter(
	_ center: UNUserNotificationCenter,
	didReceive response: UNNotificationResponse
) async {
	await DevRev.processPushNotification(response.notification.request.content.userInfo)
}
```

## Sample app
A sample app with use cases for both UIKit and SwiftUI has been provided as part of this repository.

Before you start using the sample app you will need to configure it to be used with your Apple Developer team and your DevRev credentials. For your convenience the code has been marked with compiler error directives (`#error`) at the places that need attention.

1. Add your credentials to the relevant `AppDelegate.swift` of the SwiftUI or UIKit sample.
   - After you have added the credentials, delete or comment out the compiler error lines in the respective files.
1. Configure the code signing for the sample target:
	- Open the project settings (1),
	- Select the appropriate target (2),
	- Go to the Signing & Capabilities section (3), and
	- Select your development team under Team (4).
	<img src="docs/screenshots/screenshot-xcode-signing.png" width="400" />

## Troubleshooting
- **Issue**: Can't import the SDK into my app.
	**Solution**: Double-check the setup process and ensure that `DevRevSDK` is correctly linked to your application.

- **Issue**: How does the DevRev SDK handle errors?
	**Solution**: The DevRev SDK reports all errors in the console using Apple's Unified Logging System. Look for error messages in the subsystem `ai.devrev.sdk`.

- **Issue**: Support chat won't show.
	**Solution**: Ensure you have correctly called one of the identification methods: `DevRev.identifyUnverifiedUser(...)`, `DevRev.identifyVerifiedUser(...)`, or `DevRev.identifyAnonymousUser(...)`.

- **Issue**: Not receiving push notifications.
	**Solution**: Ensure that your app is configured to receive push notifications and that your device is registered with the DevRev SDK.

## Migration guide
If you are migrating from the legacy UserExperior SDK to the new DevRev SDK, please refer to the [Migration guide](./MIGRATION.md) for detailed instructions and feature equivalence.
