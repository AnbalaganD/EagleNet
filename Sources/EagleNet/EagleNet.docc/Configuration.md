# Configuration

⚙️ Customize EagleNet with your own network service implementation.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

EagleNet allows you to configure a custom network service implementation using the `configure(networkService:)` method. This enables advanced configurations like custom URLSession settings, mock services for testing, or specialized networking behavior.

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