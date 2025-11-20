# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.5] - 2025-11-20

### Added
- Added automatic restoration of sessions lost when the app is killed.

### Changed
- Improved crash log parsing and formatting for clearer diagnostics.
- Refined the session upload pipeline improved reliability.

## [2.2.4] - 2025-11-03

### Added
- Added support to track user interactions within WebView components, improving analytics and engagement insights.
  
### Changed
- Simplified identification flow by deprecating redundant anonymous API usage.

### Fixed
- Fixed issues in the logout process to ensure complete session termination and improved reliability.

## [2.2.3] - 2025-10-13

### Added
- Added the ability to pause and resume user interaction event tracking, offering more security on the confidential screens.
  
### Changed
- Improved performance and modularity by decoupling the screen recording functionality from the main tracking flow. 

### Fixed
- Corrected incorrect or missing device model names on certain iPhone versions.
- Fixed visual distortion issues when zooming inside web view.

## [2.2.2] - 2025-09-16

### Changed
- Improved the infrastructure for custom masking.

## [2.2.1] - 2025-08-28

### Added
- Extended the sample app with masking of web views, table views and lists.

### Fixed
- Fixed the broken Objective-C signature for the `identifyVerifiedUser:sessionToken:` method.
- Fixed user properties missing in session recording.

### Changed
- Improved the API reference and integration guide.

## [2.2.0] - 2025-08-05

### Added
- Introduced custom masking controls for improved privacy management.

### Fixed
- Fixed an issue where manual unmasking did not work during session capture.
- Resolved a session recording issue affecting SwiftUI views.

## [2.1.0] - 2025-06-26

### Added
- Introduced crash reporting integrated with session recordings.
- Improved support widget navigaion.

### Fixed
- Fixed an issue with timer tracking to ensure correct session properties are recorded.

## [2.0.2] - 2025-06-12

### Fixed
- Included the actual changes intended for version [2.0.1] related to improved masking support for web views and plugins.

## [2.0.1] - 2025-06-12

### Fixed
- Improved masking support for web views and plugins.

## [2.0.0] - 2025-06-11

### Changed
- Improved the communication with the DevRev backend.
- Improved the encryption techniques used throughout the SDK.

### Removed
- The `DevRevDelegate` protocol has been removed.

## [1.1.7] - 2025-06-03

### Fixed
- Fixed an issue with the sandbox detection.

### Deprecated
- The `DevRevDelegate` protocol is deprecated. It will be removed in the next major release.

## [1.1.6] - 2025-05-19

### Fixed
- Fixed an issue where the DevRev SDK would go into an unrecoverable state.

## [1.1.5] - 2025-04-30

### Changed
- Added a flag to enforce the preferred theme for the DevRev UI, overriding system theme when enabled.
- Added support for sandbox notification testing in debug mode.

## [1.1.4] - 2025-04-02

### Changed
- Improved the handling of custom fields in user, account and organization traits.

## [1.1.3] - 2025-03-13

### Added
- Created a brand-new sample app showcasing DevRev SDK's features.
- Added support for CSS masking classes using the `devrev-mask` and `devrev-unmask` classes.

### Changed
- Improved the handling of the automatic session recording.

## [1.1.2] - 2025-03-06

### Changed
- Enhanced the session analytics feature to work better across different environments.

### Removed
- Removed the support for automatic processing of DevRev push notifications. For more info, please refer to the integration guide (README.md).

## [1.1.1] - 2025-02-25

### Fixed
- Improved the stability of the on-demand sessions feature.

## [1.1.0] - 2025-02-18

### Added
- Introducing a logout mechanism that clears the user's credentials, unregisters the device from receiving push notifications, and stops the session recording.
- Added a boolean flag to check if the SDK has been configured.
- Added a boolean flag to check if the user has been identified.
- Added a boolean flag to check if the session is being recorded.
- Added a boolean flag to check if the monitoring is enabled.
- Added a boolean flag to check if the on-demand sessions are enabled.

## [1.0.3] - 2025-02-03

### Fixed
- Fixed an issue where an already identified user could not be switched with a new user of the same type.

### Deprecated
- This version drops support for iOS versions below 15.

## [1.0.2] - 2025-01-13

### Fixed
- Fixed an issue with the verified user identification.

## [1.0.1] - 2025-01-03

### Changed
- Improved the user identification mechanism.

## [1.0.0] - 2024-12-18

### Added
- Introducing the Session Analytics feature. This feature allows you to monitor the health of your application and its components.
- Added support for Push Notifications for the PLuG support chat.
- Added support for on-demand (offline) sessions.
- Added support to create new conversations in the PLuG support chat.
- Added support for in-app link handling.
