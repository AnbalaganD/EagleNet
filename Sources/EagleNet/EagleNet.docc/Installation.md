# Installation

📦 Learn how to add EagleNet to your project.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Swift Package Manager

EagleNet is available through Swift Package Manager. Add it to your project by including the following in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/AnbalaganD/EagleNet", .upToNextMajor(from: "2.1.0"))
]
```

### Xcode Integration

1. Open your project in Xcode
2. Go to **File** → **Add Package Dependencies**
3. Enter the repository URL: `https://github.com/AnbalaganD/EagleNet`
4. Select the version rule and click **Add Package**

## Platform Support

EagleNet supports the following platforms:

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+

## Import

Once installed, import EagleNet in your Swift files:

```swift
import EagleNet
```
