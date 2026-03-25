# Error Handling

⚠️ Handle network errors gracefully.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

EagleNet provides comprehensive error handling to help you manage network failures and unexpected responses.

## Basic Error Handling

```swift
do {
    let user: User = try await EagleNet.get(
        url: "https://api.example.com/users/1"
    )
    // Handle success
} catch {
    // Handle any error
    print("Request failed: \(error)")
}
```

## Specific Error Types

```swift
do {
    let user: User = try await EagleNet.get(
        url: "https://api.example.com/users/1"
    )
} catch NetworkError.invalidURL {
    print("Invalid URL provided")
} catch NetworkError.failure(let message, let statusCode, let data) {
    print("Network error: \(message), status code: \(statusCode)")
    if let errorData = data {
        print("Response data: \(String(data: errorData, encoding: .utf8) ?? "Invalid data")")
    }
} catch NetworkError.parsingError(let error, let raw) {
    print("Failed to parse response: \(error)")
    print("Raw response: \(raw)")
} catch {
    print("Unexpected error: \(error)")
}
```

## HTTP Status Code Handling

```swift
do {
    let user: User = try await EagleNet.get(
        url: "https://api.example.com/users/1"
    )
} catch NetworkError.failure(_, let statusCode, _) {
    switch statusCode {
    case 401:
        print("Unauthorized - check your credentials")
    case 404:
        print("User not found")
    case 500...599:
        print("Server error: \(statusCode)")
    default:
        print("HTTP error: \(statusCode)")
    }
}
```

## Custom Error Handling

```swift
func handleNetworkError(_ error: Error) {
    if let networkError = error as? NetworkError {
        switch networkError {
        case .invalidURL:
            showAlert("Invalid URL")
        case .invalidFileURL:
            showAlert("Invalid file URL")
        case .invalidDirectoryPath:
            showAlert("Invalid destination directory")
        case .failure(let message, let statusCode, _):
            showAlert("HTTP Error \(statusCode): \(message)")
        case .parsingError(let error, let raw):
            showAlert("Failed to parse response: \(error)")
        }
    } else {
        showAlert("Network request failed")
    }
}
```
