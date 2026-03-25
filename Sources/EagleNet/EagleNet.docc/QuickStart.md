# Quick Start

🦅 Get up and running with EagleNet in minutes.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Your First Request

Making a network request with EagleNet is straightforward:

```swift
import EagleNet

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

// Make a GET request
let user: User = try await EagleNet.get(
    url: "https://api.example.com/users/1"
)

print("User: \(user.name)")
```

## Basic POST Request

```swift
struct CreateUser: Encodable {
    let name: String
    let email: String
}

struct UserResponse: Decodable {
    let id: Int
    let name: String
}

let newUser = CreateUser(name: "Anbalagan D", email: "anbu94p@gmail.com")
let response: UserResponse = try await EagleNet.post(
    url: "https://api.example.com/users",
    body: newUser
)
```

## Error Handling

```swift
do {
    let user: User = try await EagleNet.get(
        url: "https://api.example.com/users/1"
    )
    // Handle success
} catch {
    // Handle error
    print("Request failed: \(error)")
}
```

## Configuration (Optional)

Customize EagleNet with your own settings:

```swift
let configuration = URLSessionConfiguration.default
configuration.timeoutIntervalForRequest = 30

let customService = EagleNet.defaultService(
    urlSession: URLSession(configuration: configuration),
    jsonEncoder: JSONEncoder(),
    jsonDecoder: JSONDecoder(),
    fileManager: .default
)

EagleNet.configure(networkService: customService)
```

That's it! You're ready to start making network requests with EagleNet.