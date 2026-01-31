# ``EagleNet``

A lightweight and elegant Swift networking library built on top of URLSession.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

EagleNet provides a simple and elegant approach to writing network requests. It's designed to be lightweight, adding a thin layer on top of `URLSession` without excessive engineering overhead.

### Key Features

- **🦅 Lightweight**: Keep the library small and efficient
- **🔧 Easy to maintain**: Clear code and modular design for maintainability  
- **👋 Beginner friendly**: Accessible to developers of all levels
- **📚 Well documented**: Comprehensive documentation to guide usage
- **⚙️ Customizable and testable**: Flexible and ensures code quality through testing

Currently supports basic HTTP data requests (`GET`, `POST`, `PUT`, `DELETE`) and includes file upload using `multipart/form-data`.

## Topics

### Getting Started

- <doc:Installation>
- <doc:QuickStart>

### Making Requests

- <doc:BasicRequests>
- <doc:CustomRequests>
- <doc:FileUpload>

### Advanced Features

- <doc:RequestInterceptors>
- <doc:ResponseInterceptors>
- <doc:Configuration>
- <doc:ErrorHandling>

### Examples

- <doc:UsageExamples>

## Installation

### Swift Package Manager

Add EagleNet to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/AnbalaganD/EagleNet", .upToNextMajor(from: "2.0.4"))
]
```

## Quick Example

```swift
import EagleNet

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

// Simple GET request
let user: User = try await EagleNet.get(
    url: "https://api.example.com/users/1"
)
```

## License

EagleNet is available under the MIT license.
