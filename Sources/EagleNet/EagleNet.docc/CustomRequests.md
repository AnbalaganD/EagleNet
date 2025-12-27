# Custom Requests

🔧 Execute custom HTTP methods and advanced request configurations.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

EagleNet provides flexibility for advanced use cases through custom HTTP methods and the `execute` function. Use these when the built-in GET, POST, PUT, DELETE methods don't meet your specific requirements.

## Custom HTTP Methods

### PATCH Requests
```swift
struct UpdateStatus: Encodable {
    let status: String
}

let patchRequest = DataRequest(
    url: "https://api.example.com/users/1",
    httpMethod: .custom("PATCH"),
    body: UpdateStatus(status: "active")
)

let response: User = try await EagleNet.execute(patchRequest)

// Get raw response data
let (data, urlResponse) = try await EagleNet.execute(patchRequest)
```

### HEAD Requests
```swift
let headRequest = DataRequest(
    url: "https://api.example.com/users/1",
    httpMethod: .custom("HEAD")
)

// HEAD requests typically don't return body data
let _: EmptyResponse = try await EagleNet.execute(headRequest)
```

### OPTIONS Requests
```swift
let optionsRequest = DataRequest(
    url: "https://api.example.com/users",
    httpMethod: .custom("OPTIONS")
)

let corsInfo: CORSResponse = try await EagleNet.execute(optionsRequest)
```

## Advanced Request Configuration

### Custom Headers and Parameters
```swift
var customRequest = DataRequest(
    url: "https://api.example.com/data",
    httpMethod: .get
)

customRequest.addHeader(key: "X-API-Version", value: "2.0")
customRequest.addHeader(key: "Accept-Language", value: "en-US")
customRequest.addParameter(key: "filter", value: "active")
customRequest.addParameter(key: "sort", value: "name")

let data: APIResponse = try await EagleNet.execute(customRequest)
```

## Custom NetworkRequestable Implementation

For complete control, implement your own NetworkRequestable:

```swift
struct CustomAPIRequest: NetworkRequestable {
    let url: any URLConvertible
    let path: String?
    let httpMethod: HTTPMethod
    let headers: [String: String]?
    let parameters: [String: String]?
    let body: Body?  // Body is any Encodable or Data
    let contentType: ContentType
    
    init(endpoint: String, apiKey: String) {
        self.url = "https://api.example.com"
        self.path = endpoint
        self.httpMethod = .get
        self.headers = ["X-API-Key": apiKey]
        self.parameters = nil
        self.body = nil
        self.contentType = .applicationJSON
    }
}

// Usage
let customRequest = CustomAPIRequest(endpoint: "/users", apiKey: "your-key")
let users: [User] = try await EagleNet.execute(customRequest)
```
