//
//  EagleNet+Get.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Extension providing GET request convenience methods for EagleNet
extension EagleNet {
    /// Performs a GET request
    ///
    /// Example usage:
    /// ```swift
    /// struct SearchParams: Encodable {
    ///     let query: String
    ///     let filter: String
    /// }
    ///
    /// let params = SearchParams(query: "swift", filter: "language")
    /// let results: SearchResults = try await EagleNet.get(
    ///     url: "https://api.example.com",
    ///     path: "/search",
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
    public static func get<Response: Decodable>(
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
                httpMethod: .get,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }

    /// Performs a GET request returning raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``get(url:path:headers:parameters:body:)->Response`` for the decoded response variant.
    /// 
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body (any Encodable type or Data)
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the request fails
    public static func get(
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
                httpMethod: .get,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
}
