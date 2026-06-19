//
//  DataRequest.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

/// A structure that represents an HTTP request with all necessary components.
///
/// Example usage:
/// ```swift
/// // Create a basic GET request
/// let getRequest = DataRequest(
///     url: "https://api.example.com",
///     path: "/users"
/// )
///
/// // Create a POST request with body
/// var postRequest = DataRequest(
///     url: "https://api.example.com",
///     path: "/users",
///     httpMethod: .post
/// )
/// postRequest.setBody(User(name: "John", age: 30))
/// postRequest.addHeader(key: "Authorization", value: "Bearer token123")
/// ```
public struct DataRequest: NetworkRequestable, @unchecked Sendable {
    /// The base URL for the request
    public let url: any URLConvertible

    /// Optional path component to append to the base URL
    public let path: String?

    /// HTTP method for the request (GET, POST, PUT, DELETE, etc.)
    public let httpMethod: HTTPMethod

    /// Optional HTTP headers for the request
    public private(set) var headers: [String: String]?

    /// Optional query parameters for the request
    public private(set) var parameters: [String: String]?

    /// Optional body data for the request (any Encodable type or Data)
    public private(set) var body: Body?

    /// Content type of the request (defaults to application/json)
    public var contentType: ContentType? { .applicationJSON }

    /// Creates a new request with the specified parameters
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - httpMethod: HTTP method (defaults to GET)
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body (any Encodable type or Data)
    public init(
        url: any URLConvertible,
        path: String? = nil,
        httpMethod: HTTPMethod = .get,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: Body? = nil
    ) {
        self.url = url
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
        self.body = body
    }

    /// Adds a single header to the request
    /// - Parameters:
    ///   - key: Header name
    ///   - value: Header value
    mutating func addHeader(key: String, value: String) {
        if headers == nil {
            headers = [:]
        }

        headers?[key] = value
    }

    /// Adds multiple headers to the request
    /// - Parameter contents: Dictionary of headers to add
    mutating func addHeader(
        contentsOf contents: [String: String]
    ) {
        if headers == nil {
            headers = contents
        } else {
            for (key, value) in contents {
                headers?[key] = value
            }
        }
    }

    /// Adds a single query parameter to the request
    /// - Parameters:
    ///   - key: Parameter name
    ///   - value: Parameter value
    mutating func addParameter(key: String, value: String) {
        if parameters == nil {
            parameters = [:]
        }

        parameters?[key] = value
    }

    /// Adds multiple query parameters to the request
    /// - Parameter contents: Dictionary of parameters to add
    mutating func addParameter(
        contentsOf contents: [String: String]
    ) {
        if parameters == nil {
            parameters = contents
        } else {
            for (key, value) in contents {
                parameters?[key] = value
            }
        }
    }

    /// Sets the request body
    /// - Parameter body: The request body (any Encodable type or Data)
    mutating func setBody(_ body: Body) {
        self.body = body
    }
}
