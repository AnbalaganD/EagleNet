//
//  EagleNet+Upload.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Extension providing file upload convenience methods for EagleNet
extension EagleNet {
    /// Performs a multipart form-data upload request
    ///
    /// Example usage:
    /// ```swift
    /// let client = EagleNet()
    ///
    /// // Upload an image with additional form fields
    /// let imageData = // ... your image data ...
    /// let response: UploadResponse = try await client.upload(
    ///     url: "https://api.example.com",
    ///     path: "/upload",
    ///     headers: ["Authorization": "Bearer token123"],
    ///     parameters: [
    ///         .file(
    ///             key: "avatar",
    ///             fileName: "profile.jpg",
    ///             data: imageData,
    ///             mimeType: .jpegImage
    ///         ),
    ///         .text(key: "username", value: "johndoe")
    ///     ],
    ///     progress: { bytesUploaded, totalBytes in
    ///         let percentage = Float(bytesUploaded) / Float(totalBytes) * 100
    ///         print("Upload progress: \(Int(percentage))%")
    ///     }
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - url: The base URL for the upload request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - queryParameters: Optional URL query parameters
    ///   - parameters: Array of MultipartParameter (files and text fields)
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the upload fails or response cannot be decoded
    public func upload<Response: Decodable>(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        parameters: [MultipartParameter] = [],
        progress: ProgressHandler? = nil
    ) async throws -> Response {
        try await networkService.upload(
            makeRequest(
                url: url,
                path: path,
                headers: headers,
                queryParameters: queryParameters,
                parameters: parameters
            ),
            progress: progress
        )
    }
    
    /// Performs a multipart form-data upload request returning raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``upload(url:path:headers:queryParameters:parameters:progress:)->Response``
    /// for the decoded response variant.
    ///
    /// - Parameters:
    ///   - url: The base URL for the upload request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - queryParameters: Optional URL query parameters
    ///   - parameters: Array of MultipartParameter (files and text fields)
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the upload fails
    public func upload(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        parameters: [MultipartParameter] = [],
        progress: ProgressHandler? = nil
    ) async throws -> (Data, URLResponse) {
        try await networkService.upload(
            makeRequest(
                url: url,
                path: path,
                headers: headers,
                queryParameters: queryParameters,
                parameters: parameters
            ),
            progress: progress
        )
    }
    
    /// Performs a multipart form-data upload request
    ///
    /// Example usage:
    /// ```swift
    /// // Upload an image with additional form fields
    /// let imageData = // ... your image data ...
    /// let response: UploadResponse = try await EagleNet.upload(
    ///     url: "https://api.example.com",
    ///     path: "/upload",
    ///     headers: ["Authorization": "Bearer token123"],
    ///     parameters: [
    ///         .file(
    ///             key: "avatar",
    ///             fileName: "profile.jpg",
    ///             data: imageData,
    ///             mimeType: .jpegImage
    ///         ),
    ///         .text(key: "username", value: "johndoe")
    ///     ],
    ///     progress: { bytesUploaded, totalBytes in
    ///         let percentage = Float(bytesUploaded) / Float(totalBytes) * 100
    ///         print("Upload progress: \(Int(percentage))%")
    ///     }
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - url: The base URL for the upload request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - queryParameters: Optional URL query parameters
    ///   - parameters: Array of MultipartParameter (files and text fields)
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the upload fails or response cannot be decoded
    public static func upload<Response: Decodable>(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        parameters: [MultipartParameter] = [],
        progress: ProgressHandler? = nil
    ) async throws -> Response {
        try await shared.upload(
            url: url,
            path: path,
            headers: headers,
            queryParameters: queryParameters,
            parameters: parameters,
            progress: progress
        )
    }

    /// Performs a multipart form-data upload request returning raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``upload(url:path:headers:queryParameters:parameters:progress:)->Response``
    /// for the decoded response variant.
    ///
    /// - Parameters:
    ///   - url: The base URL for the upload request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - queryParameters: Optional URL query parameters
    ///   - parameters: Array of MultipartParameter (files and text fields)
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the upload fails
    public static func upload(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        parameters: [MultipartParameter] = [],
        progress: ProgressHandler? = nil
    ) async throws -> (Data, URLResponse) {
        try await shared.upload(
            url: url,
            path: path,
            headers: headers,
            queryParameters: queryParameters,
            parameters: parameters,
            progress: progress
        )
    }

    private func makeRequest(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        parameters: [MultipartParameter] = []
    ) -> MultipartRequest {
        var request = MultipartRequest(
            url: url,
            path: path,
            httpMethod: .post,
            headers: headers,
            parameters: queryParameters
        )

        for parameter in parameters {
            switch parameter {
            case .file(let key, let fileName, let data, let mimeType):
                request.addBodyParameter(
                    key: key,
                    value: data,
                    fileName: fileName,
                    contentType: mimeType
                )
            case .text(let key, let value):
                request.addBodyParameter(
                    key: key,
                    value: value
                )
            }
        }

        return request
    }
}
