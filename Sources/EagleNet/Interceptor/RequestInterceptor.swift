//
//  RequestInterceptor.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// This protocol allows you to modify a network request before it is submitted.
/// Implement this to customize the request as needed.
///
/// ```swift
/// struct AuthInterceptor: RequestInterceptor {
///     let token: String
///     func modify(request: URLRequest) async throws -> URLRequest {
///         var modifiedRequest = request // Add an Authorization header to the request
///         modifiedRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
///         return modifiedRequest
///     }
/// }
/// ```
public protocol RequestInterceptor: Sendable {
    func modify(request: URLRequest) async throws -> URLRequest
}
