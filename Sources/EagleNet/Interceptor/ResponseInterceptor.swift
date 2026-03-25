//
//  ResponseInterceptor.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// This protocol is used to intercept the response before it is returned to the caller.
/// It is useful for modifying the response `Data`, `URL` for download requests, or `URLResponse`.
///
/// ```swift
/// struct MyResponseInterceptor: ResponseInterceptor {
///    func modify(data: Data, urlResponse: URLResponse) async throws -> (Data, URLResponse) {
///        // Modify the data or URLResponse here
///        return (data, urlResponse)
///    }
///
///    func modify(url: URL, urlResponse: URLResponse) async throws -> (URL, URLResponse) {
///        // Modify the downloaded file URL or URLResponse here
///        return (url, urlResponse)
///    }
/// }
/// ```
public protocol ResponseInterceptor: Sendable {
    /// Intercepts a response where the data is loaded into memory (e.g. GET, POST).
    ///
    /// This method allows you to modify the `Data` or `URLResponse` before they are decoded
    /// and passed back to the caller.
    ///
    /// - Parameters:
    ///   - data: The raw response data in memory.
    ///   - urlResponse: The HTTP response metadata from the server.
    /// - Returns: A tuple potentially containing a modified `Data` and `URLResponse`.
    /// - Throws: Any error that should interrupt the flow.
    func modify(
        data: consuming Data,
        urlResponse: consuming URLResponse
    ) async throws -> (Data, URLResponse)

    /// Intercepts a response for a download request after the payload has been saved to a local file URL.
    ///
    /// This method is specifically used by download APIs, such as `EagleNet.download(...)`.
    /// It allows you to modify the resulting local file `URL` or `URLResponse`
    /// before the download result is returned to the caller.
    ///
    /// - Parameters:
    ///   - url: The local file URL where the downloaded content is saved.
    ///   - urlResponse: The HTTP response metadata from the server.
    /// - Returns: A tuple potentially containing a modified `URL` and `URLResponse`.
    /// - Throws: Any error that should interrupt the flow.
    func modify(
        url: consuming URL,
        urlResponse: consuming URLResponse
    ) async throws -> (URL, URLResponse)
}

public extension ResponseInterceptor {
    func modify(
        data: consuming Data,
        urlResponse: consuming URLResponse
    ) async throws -> (Data, URLResponse) {
        (data, urlResponse)
    }

    func modify(
        url: consuming URL,
        urlResponse: consuming URLResponse
    ) async throws -> (URL, URLResponse) {
        (url, urlResponse)
    }
}
