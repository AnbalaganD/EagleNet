//
//  HTTPMethod.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

/// Represents HTTP request methods used in network operations.
///
/// This struct provides a type-safe way to specify HTTP methods for network requests.
/// EagleNet supports the standard HTTP methods: GET, POST, PUT, DELETE, and custom methods.
///
/// ## Usage
/// ```swift
/// // Using predefined HTTP methods
/// let getRequest = DataRequest(
///     url: "https://api.example.com/users",
///     httpMethod: .get
/// )
///
/// let postRequest = DataRequest(
///     url: "https://api.example.com/users",
///     httpMethod: .post,
///     body: newUser
/// )
///
/// // Custom HTTP method if needed
/// let patch = HTTPMethod.custom("PATCH")
/// ```
public struct HTTPMethod: RawRepresentable, Sendable {
    /// The string representation of the HTTP method
    public let rawValue: String

    /// Creates a new HTTP method with the specified raw value
    /// - Parameter rawValue: The string representation of the HTTP method
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// HTTP GET method for retrieving resources
    public static let get = HTTPMethod(rawValue: "GET")

    /// HTTP POST method for creating resources
    public static let post = HTTPMethod(rawValue: "POST")

    /// HTTP PUT method for updating resources
    public static let put = HTTPMethod(rawValue: "PUT")

    /// HTTP DELETE method for removing resources
    public static let delete = HTTPMethod(rawValue: "DELETE")

    /// Creates a custom HTTP method with the specified method string
    ///
    /// Use this method to create HTTP methods that are not predefined in EagleNet.
    /// This is useful for REST APIs that use non-standard HTTP methods like PATCH, HEAD, OPTIONS, etc.
    ///
    /// - Parameter method: The HTTP method string (e.g., "PATCH", "HEAD", "OPTIONS")
    /// - Returns: HTTPMethod instance for the custom method
    ///
    /// ## Usage Examples
    /// ```swift
    /// // PATCH method for partial updates
    /// let patchMethod = HTTPMethod.custom("PATCH")
    ///
    /// // HEAD method for checking resource existence
    /// let headMethod = HTTPMethod.custom("HEAD")
    ///
    /// // OPTIONS method for CORS preflight
    /// let optionsMethod = HTTPMethod.custom("OPTIONS")
    /// ```
    public static func custom(_ method: String) -> HTTPMethod {
        HTTPMethod(rawValue: method)
    }
}
