//
//  NetworkRequestable.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

/// Protocol defining the requirements for a network request.
///
/// This protocol represents the core components needed to construct an HTTP request.
/// It's used by the EagleNet library to standardize how requests are created and processed.
/// 
/// The protocol provides default implementations for most properties through extensions,
/// making it easier to create custom requests without implementing every property.
///
/// ## Example Implementation
/// ```swift
/// struct UserRequest: NetworkRequestable {
///     let url: URLConvertible = "https://api.example.com"
///     let path: String? = "/users"
///     let httpMethod: HTTPMethod = .get
///     let headers: [String: String]? = ["Authorization": "Bearer token123"]
///     let parameters: [String: String]? = ["page": "1", "limit": "10"]
///     let body: Body? = nil  // Body is any Encodable or Data
///     let contentType: ContentType = .applicationJSON
/// }
///
/// // Using the request
/// let users: [User] = try await EagleNet.execute(UserRequest())
/// ```
///
/// For most common use cases, you can use the built-in `DataRequest` and `MultipartRequest` implementation
/// instead of creating your own custom type.
public protocol NetworkRequestable: Sendable {
    /// The base URL for the request
    var url: any URLConvertible { get }

    /// Optional path to append to the base URL
    var path: String? { get }

    /// The HTTP method for the request (GET, POST, PUT, DELETE, etc.)
    var httpMethod: HTTPMethod { get }

    /// Optional HTTP headers to include with the request
    var headers: [String: String]? { get }

    /// Optional query parameters to include in the URL
    var parameters: [String: String]? { get }

    /// Optional request body (any Encodable type or Data)
    var body: Body? { get }

    /// The content type of the request (e.g., application/json)
    var contentType: ContentType? { get }
}
