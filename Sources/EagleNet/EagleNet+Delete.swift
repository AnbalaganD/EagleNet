//
//  EagleNet+Delete.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Extension providing DELETE request convenience methods for EagleNet
extension EagleNet {
    /// Performs a DELETE request
    ///
    /// Example usage:
    /// ```swift
    /// let client = EagleNet()
    ///
    /// struct DeleteParams: Encodable {
    ///     let reason: String
    ///     let permanent: Bool
    /// }
    ///
    /// let params = DeleteParams(reason: "Account closed", permanent: true)
    /// let response: DeleteResponse = try await client.delete(
    ///     url: "https://api.example.com",
    ///     path: "/accounts/123",
    ///     body: params
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
    public func delete<Response: Decodable>(
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
                httpMethod: .delete,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }

    /// Performs a DELETE request returning raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``delete(url:path:headers:parameters:body:)->Response`` for the decoded response variant.
    /// 
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body (any Encodable type or Data)
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the request fails
    public func delete(
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
                httpMethod: .delete,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
    
    /// Performs a DELETE request
    ///
    /// Example usage:
    /// ```swift
    /// struct DeleteParams: Encodable {
    ///     let reason: String
    ///     let permanent: Bool
    /// }
    ///
    /// let params = DeleteParams(reason: "Account closed", permanent: true)
    /// let response: DeleteResponse = try await EagleNet.delete(
    ///     url: "https://api.example.com",
    ///     path: "/accounts/123",
    ///     body: params
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
    public static func delete<Response: Decodable>(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: Body? = nil
    ) async throws -> Response {
        try await shared.delete(
            url: url,
            path: path,
            headers: headers,
            parameters: parameters,
            body: body
        )
    }

    /// Performs a DELETE request returning raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``delete(url:path:headers:parameters:body:)->Response`` for the decoded response variant.
    /// 
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body (any Encodable type or Data)
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the request fails
    public static func delete(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: Body? = nil
    ) async throws -> (Data, URLResponse) {
        try await shared.delete(
            url: url,
            path: path,
            headers: headers,
            parameters: parameters,
            body: body
        )
    }
}
