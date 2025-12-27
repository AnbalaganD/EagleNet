# Basic Requests

🚀 Learn how to make GET, POST, PUT, and DELETE requests.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## GET Requests

Retrieve data from a server:

```swift
struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

let user: User = try await EagleNet.get(
    url: "https://api.example.com/users/1"
)

// Get raw response data
let (data, response) = try await EagleNet.get(
    url: "https://api.example.com/users/1"
)
```

## POST Requests

Send data to create new resources:

```swift
struct CreateUser: Encodable {
    let name: String
    let email: String
}

struct UserResponse: Decodable {
    let id: Int
    let name: String
}

let newUser = CreateUser(name: "Anbu D", email: "anbu@example.com")
let response: UserResponse = try await EagleNet.post(
    url: "https://api.example.com/users",
    body: newUser
)

// Get raw response data
let (data, urlResponse) = try await EagleNet.post(
    url: "https://api.example.com/users",
    body: newUser
)
```

## PUT Requests

Update existing resources:

```swift
struct UpdateUser: Encodable {
    let name: String
    let email: String
}

let updatedUser = UpdateUser(name: "Anbu D", email: "anbu@example.com")
let response: UserResponse = try await EagleNet.put(
    url: "https://api.example.com/users/1",
    body: updatedUser
)

// Get raw response data
let (data, urlResponse) = try await EagleNet.put(
    url: "https://api.example.com/users/1",
    body: updatedUser
)
```

## DELETE Requests

Remove resources:

```swift
let response: DeleteResponse = try await EagleNet.delete(
    url: "https://api.example.com/users/1"
)

// Get raw response data
let (data, urlResponse) = try await EagleNet.delete(
    url: "https://api.example.com/users/1"
)
```