//
//  HTTPURLResponseExtension.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension HTTPURLResponse {
    /// Convenience property for checking if an `HTTPURLResponse` is successful.
    ///
    /// Returns `true` if the status code is in the range of 200 to 299 (inclusive),
    /// indicating a successful HTTP response.
    var isSuccess: Bool { 200 ... 299 ~= statusCode }
}
