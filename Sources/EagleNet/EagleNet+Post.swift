//
//  EagleNet+Post.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Extension providing POST request convenience methods for EagleNet
extension EagleNet {
    /// Performs a POST request
    ///
    /// Example usage:
    /// ```swift
    /// struct CreateUser: Encodable {
    ///     let name: String
    ///     let email: String
    /// }
    ///
    /// let user = CreateUser(name: "John Doe", email: "john@example.com")
    /// let response: UserResponse = try await EagleNet.post(
    ///     url: "https://api.example.com",
    ///     path: "/users",
    ///     body: user
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body (any Encodable type or Data)
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the request fails or response cannot be decoded
    public static func post<Response: Decodable>(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: Body? = nil
    ) async throws -> Response {
        try await networkService.execute(
            DataRequest(
                url: url,
                path: path,
                httpMethod: .post,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }

    /// Performs a POST request returning raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``post(url:path:headers:parameters:body:)->Response`` for the decoded response variant.
    /// 
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body (any Encodable type or Data)
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the request fails
    public static func post(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: Body? = nil
    ) async throws -> (Data, URLResponse) {
        try await networkService.execute(
            DataRequest(
                url: url,
                path: path,
                httpMethod: .post,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
}
