# Configuration

⚙️ Customize EagleNet with your own network service implementation.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

EagleNet supports both a shared static style and multiple instance style.

- Use `EagleNet.get(...)`, `EagleNet.post(...)`, and the other static convenience APIs when one app-wide networking setup is enough.
- Create separate `EagleNet` instances when different features need different URL sessions, interceptors, base URLs, or mock services.

You can also configure a custom network service implementation using the `configure(networkService:)` method. This enables advanced configurations like custom URLSession settings, mock services for testing, or specialized networking behavior.

## Basic Configuration

```swift
import EagleNet

// Configure with custom URLSession
let configuration = URLSessionConfiguration.default
configuration.timeoutIntervalForRequest = 30
configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

let customService = EagleNet.defaultService(
    urlSession: URLSession(configuration: configuration),
    jsonEncoder: JSONEncoder(),
    jsonDecoder: JSONDecoder(),
    fileManager: .default
)

EagleNet.configure(networkService: customService)
```

## Shared Style

```swift
import EagleNet

struct User: Decodable {
    let id: Int
    let name: String
}

let user: User = try await EagleNet.get(
    url: "https://api.example.com",
    path: "/users/1"
)
```

## Separate Instance Per Requirement

```swift
import EagleNet

struct User: Decodable {
    let id: Int
    let name: String
}

let authClient = EagleNet(
    networkService: EagleNet.defaultService(
        urlSession: .shared,
        jsonEncoder: JSONEncoder(),
        jsonDecoder: JSONDecoder(),
        fileManager: .default
    )
)

let filesClient = EagleNet(
    networkService: EagleNet.defaultService(
        urlSession: URLSession(configuration: .ephemeral),
        jsonEncoder: JSONEncoder(),
        jsonDecoder: JSONDecoder(),
        fileManager: .default
    )
)

let authUser: User = try await authClient.get(
    url: "https://auth.example.com",
    path: "/users/me"
)
```

Use separate instances when a module needs its own network configuration or a test needs a mock service.

## Testing Configuration

```swift
// Mock service for unit testing
class MockNetworkService: NetworkService {
    // Implementation for testing
}

let mockService = MockNetworkService()
EagleNet.configure(networkService: mockService)
```

## Custom JSON Configuration

```swift
let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .iso8601

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

let service = EagleNet.defaultService(
    urlSession: .shared,
    jsonEncoder: encoder,
    jsonDecoder: decoder,
    fileManager: .default
)

EagleNet.configure(networkService: service)
```

> Important: Call `configure(networkService:)` before making any network requests to ensure the custom configuration is applied consistently.