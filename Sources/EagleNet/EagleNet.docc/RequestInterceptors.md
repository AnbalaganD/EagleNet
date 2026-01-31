# Request Interceptors

🔍 Modify requests before they are sent.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

Request interceptors allow you to modify outgoing requests, such as adding authentication headers, logging, or request transformation.

## Creating a Request Interceptor

Implement the `RequestInterceptor` protocol:

```swift
struct AuthInterceptor: RequestInterceptor {
    let token: String
    
    func modify(request: consuming URLRequest) async throws -> URLRequest {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
```

## Adding Interceptors

Register your interceptor with EagleNet:

```swift
EagleNet.addRequestInterceptor(
    AuthInterceptor(token: "your-auth-token")
)
```

## Common Use Cases

### Authentication

```swift
struct AuthInterceptor: RequestInterceptor {
    let token: String
    
    func modify(request: consuming URLRequest) async throws -> URLRequest {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
```

### API Key

```swift
struct APIKeyInterceptor: RequestInterceptor {
    let apiKey: String
    
    func modify(request: consuming URLRequest) async throws -> URLRequest {
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        return request
    }
}
```

### Request Logging

```swift
struct RequestLoggingInterceptor: RequestInterceptor {
    func modify(request: consuming URLRequest) async throws -> URLRequest {
        print("🚀 Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        return request
    }
}
```