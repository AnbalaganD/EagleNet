This library aims to provide a simple and elegant approach to writing network requests. It's designed to be lightweight, adding a thin layer on top of `URLSession` without excessive engineering overhead. 

#### Our primary objectives are:

- **Lightweight networking library:** Keep the library small and efficient.
- **Easy to maintain:** Prioritize clear code and modular design for maintainability.
- **Beginner friendly:** Make the library accessible to developers of all levels.
- **Well documented:** Provide comprehensive documentation to guide usage.
- **Customizable and testable:** Allow for flexibility and ensure code quality through testing.


Currently, this library supports basic HTTP data requests (`GET`, `POST`, `PUT`, `DELETE`), custom HTTP methods, and includes a small file upload feature using `multipart/form-data`. These capabilities address the majority of network communication needs in most applications.<br><br>


For detailed information on feature status, please refer to the [Roadmap](https://github.com/AnbalaganD/EagleNet/wiki/Roadmap) file.
<br><br>
See the complete documentation here: [Documentation](https://swiftpackageindex.com/AnbalaganD/EagleNet/main/documentation/eaglenet)
<br><br>

### Swift Package Manager (SPM)<br/> [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAnbalaganD%2FEagleNet%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/AnbalaganD/EagleNet) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAnbalaganD%2FEagleNet%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/AnbalaganD/EagleNet)

EagleNet is available through [SPM](https://swiftpackageindex.com/AnbalaganD/EagleNet). Use the URL below to add it as a dependency.

```swift
dependencies: [
    .package(url: "https://github.com/AnbalaganD/EagleNet", .upToNextMajor(from: "2.0.3"))
]
```

### Making a GET Request

```swift
import EagleNet

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

// Basic GET request
let user: User = try await EagleNet.get(
    url: "https://api.example.com/users/1"
)

// Get raw response data
let (data, response) = try await EagleNet.get(
    url: "https://api.example.com/users/1"
)
```

### Making a POST Request

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

// Get raw response data
let (data, urlResponse) = try await EagleNet.post(
    url: "https://api.example.com/users",
    body: newUser
)
```

### File Upload

```swift
let imageData = // ... your image data ...
let response: UploadResponse = try await EagleNet.upload(
    url: "https://api.example.com/upload",
    parameters: [
        .file(
            key: "avatar",
            fileName: "profile.jpg",
            data: imageData,
            mimeType: .jpegImage
        ),
        .text(key: "username", value: "Anbu")
    ],
    progress: { bytesTransferred, totalBytes in
        let progress = Float(bytesTransferred) / Float(totalBytes)
        print("Upload progress: \(Int(progress * 100))%")
    }
)

// Get raw response data
let (data, urlResponse) = try await EagleNet.upload(
    url: "https://api.example.com/upload",
    parameters: [
        .file(key: "avatar", fileName: "profile.jpg", data: imageData, mimeType: .jpegImage)
    ]
)
```

### Request Interceptors

```swift
struct AuthInterceptor: RequestInterceptor {
    let token: String
    
    func modify(request: consuming URLRequest) async throws -> URLRequest {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

// Add interceptor to network service
EagleNet.addRequestInterceptor(
    AuthInterceptor(token: "your-auth-token")
)
```

### Response Interceptors
```swift
struct LoggingInterceptor: ResponseInterceptor {
    func modify(data: consuming Data, urlResponse: consuming URLResponse) async throws -> (Data, URLResponse) {
        if let httpResponse = urlResponse as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Headers: \(httpResponse.allHeaderFields)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
        }
        return (data, urlResponse)
    }
}

// Add response interceptor to network service
EagleNet.addResponseInterceptor(LoggingInterceptor())
```

### Custom HTTP Methods

```swift
// Using custom HTTP methods like PATCH
struct UpdateStatus: Encodable {
    let status: String
}

let patchRequest = DataRequest(
    url: "https://api.example.com/users/1",
    httpMethod: .custom("PATCH"),
    body: UpdateStatus(status: "active")
)

let response: User = try await EagleNet.execute(patchRequest)
```

### Configuration

```swift
// Custom URLSession configuration
let customService = EagleNet.defaultService(
    urlSession: URLSession(configuration: .ephemeral),
    jsonEncoder: JSONEncoder(),
    jsonDecoder: JSONDecoder()
)

EagleNet.configure(networkService: customService)
```

## Author

[Anbalagan D](mailto:anbu94p@gmail.com)

## License

EagleNet is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
