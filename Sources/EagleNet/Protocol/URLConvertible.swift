//
//  URLConvertible.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

/// Protocol for types that can be converted to a URL
///
/// This protocol allows for flexible URL handling in network requests.
/// Both String and URL conform to this protocol by default, allowing
/// them to be used interchangeably when specifying URLs.
///
/// ## Example Usage
/// ```swift
/// // Using a string URL
/// let request1 = DataRequest(
///     url: "https://api.example.com/users",
///     httpMethod: .get
/// )
///
/// // Using a URL object
/// let url = URL(string: "https://api.example.com/users")!
/// let request2 = DataRequest(
///     url: url,
///     httpMethod: .get
/// )
/// ```
public protocol URLConvertible: Sendable {
    /// Converts the implementing type to a URL
    /// - Returns: A URL object
    /// - Throws: NetworkError.invalidURL if conversion fails
    func asURL() throws -> URL
}

public extension URLConvertible where Self == String {
    /// Converts a string to a URL
    /// - Returns: A URL created from the string
    /// - Throws: NetworkError.invalidURL if the string is not a valid URL
    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw NetworkError.invalidURL
        }

        return url
    }
}

public extension URLConvertible where Self == URL {
    /// Returns the URL directly since it's already a URL
    /// - Returns: The URL itself
    func asURL() throws -> URL { self }
}

/// Extends URLComponents to convert itself into a URL when used as a URLConvertible
public extension URLConvertible where Self == URLComponents {
    /// Converts the URLComponents instance into a URL.
    /// - Returns: A valid `URL` constructed from the components.
    /// - Throws: `NetworkError.invalidURL` if the components cannot be represented as a valid URL.
    func asURL() throws -> URL {
        guard let url = self.url else {
            throw NetworkError.invalidURL
        }

        return url
    }
}

/// Extends String to conform to URLConvertible
extension String: URLConvertible { }

/// Extends URL to conform to URLConvertible
extension URL: URLConvertible { }

/// Extends URLComponents to conform to URLConvertible
extension URLComponents: URLConvertible { }
