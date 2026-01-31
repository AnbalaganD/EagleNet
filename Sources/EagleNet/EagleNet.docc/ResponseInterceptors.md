# Response Interceptors

📝 Process responses before they are returned.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

Response interceptors allow you to process incoming responses, such as logging, caching, or response transformation.

## Creating a Response Interceptor

Implement the `ResponseInterceptor` protocol:

```swift
struct LoggingInterceptor: ResponseInterceptor {
    func modify(data: consuming Data, urlResponse: consuming URLResponse) async throws -> (Data, URLResponse) {
        if let httpResponse = urlResponse as? HTTPURLResponse {
            print("📥 Response Status: \(httpResponse.statusCode)")
            print("📥 Response Headers: \(httpResponse.allHeaderFields)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Response Body: \(responseString)")
            }
        }
        return (data, urlResponse)
    }
}
```

## Adding Interceptors

Register your interceptor with EagleNet:

```swift
EagleNet.addResponseInterceptor(LoggingInterceptor())
```

## Common Use Cases

### Response Logging

```swift
struct ResponseLoggingInterceptor: ResponseInterceptor {
    func modify(data: consuming Data, urlResponse: consuming URLResponse) async throws -> (Data, URLResponse) {
        if let httpResponse = urlResponse as? HTTPURLResponse {
            print("📥 \(httpResponse.statusCode) - \(httpResponse.url?.absoluteString ?? "")")
        }
        return (data, urlResponse)
    }
}
```

### Error Response Handling

```swift
struct ErrorHandlingInterceptor: ResponseInterceptor {
    func modify(data: consuming Data, urlResponse: consuming URLResponse) async throws -> (Data, URLResponse) {
        if let httpResponse = urlResponse as? HTTPURLResponse,
           httpResponse.statusCode >= 400 {
            // Log error or perform custom error handling
            print("❌ HTTP Error: \(httpResponse.statusCode)")
        }
        return (data, urlResponse)
    }
}
```

### Response Caching

```swift
struct CachingInterceptor: ResponseInterceptor {
    func modify(data: consuming Data, urlResponse: consuming URLResponse) async throws -> (Data, URLResponse) {
        // Implement caching logic
        if let httpResponse = urlResponse as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            // Cache successful responses
        }
        return (data, urlResponse)
    }
}
```