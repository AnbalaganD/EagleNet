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
/// It is useful for modifying the response Data or URLResponse.
///
/// ```swift
/// struct MyResponseInterceptor: ResponseInterceptor {
///    func modify(data: Data, urlResponse: URLResponse) async throws -> (Data, URLResponse) {
///        // Modify the data or URLResponse here
///        return (data, urlResponse)
///    }
/// }
/// ```
public protocol ResponseInterceptor: Sendable {
    func modify(
        data: Data,
        urlResponse: URLResponse
    ) async throws -> (Data, URLResponse)
}
