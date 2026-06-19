//
//  MultipartRequest.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

/// A structure that represents a multipart/form-data request for file uploads and form submissions.
///
/// Example usage:
/// ```swift
/// // Create a multipart request for file upload
/// var request = MultipartRequest(url: "https://api.example.com/upload")
///
/// // Add file data
/// request.addBodyParameter(
///     key: "avatar",
///     value: imageData,
///     fileName: "profile.jpg",
///     contentType: .jpegImage
/// )
///
/// // Add text fields
/// request.addBodyParameter(key: "username", value: "john_doe")
/// ```
public struct MultipartRequest: NetworkRequestable {
    /// The base URL for the request
    public let url: any URLConvertible

    /// Optional path component to append to the base URL
    public let path: String?

    /// HTTP method for the request (defaults to POST)
    public let httpMethod: HTTPMethod

    /// Optional HTTP headers for the request
    public private(set) var headers: [String: String]?

    /// Optional query parameters for the request
    public private(set) var parameters: [String: String]?

    /// Internal storage for multipart form data
    private var data = Data()

    /// The compiled body data with boundary terminator
    public var body: Body? {
        if data.isEmpty { return nil }

        var finalData = data
        finalData.append("--\(boundary)--")
        return finalData
    }

    /// Content type with multipart boundary
    public var contentType: ContentType? {
        .init("\(ContentType.multipartFormData); boundary=\(boundary)")
    }

    /// Unique boundary string for separating form parts
    public let boundary = "Boundary-\(UUID().uuidString)"

    /// CRLF separator for multipart sections
    private let separator = "\r\n"

    /// Standard content disposition header
    private let contentDisposition = "Content-Disposition: form-data; name="

    /// Creates a new multipart form request
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - httpMethod: HTTP method (defaults to POST)
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    public init(
        url: any URLConvertible,
        path: String? = nil,
        httpMethod: HTTPMethod = .post,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil
    ) {
        self.url = url
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
    }

    /// Adds a single header to the request
    /// - Parameters:
    ///   - key: Header name
    ///   - value: Header value
    mutating func addHeader(key: String, value: String) {
        if headers == nil {
            headers = [:]
        }

        headers?[key] = value
    }

    /// Adds multiple headers to the request
    /// - Parameter contents: Dictionary of headers to add
    mutating func addHeader(
        contentsOf contents: [String: String]
    ) {
        if headers == nil {
            headers = contents
        } else {
            for (key, value) in contents {
                headers?[key] = value
            }
        }
    }

    /// Adds a single query parameter to the request
    /// - Parameters:
    ///   - key: Parameter name
    ///   - value: Parameter value
    mutating func addParameter(key: String, value: String) {
        if parameters == nil {
            parameters = [:]
        }

        parameters?[key] = value
    }

    /// Adds multiple query parameters to the request
    /// - Parameter contents: Dictionary of parameters to add
    mutating func addParameter(
        contentsOf contents: [String: String]
    ) {
        if parameters == nil {
            parameters = contents
        } else {
            for (key, value) in contents {
                parameters?[key] = value
            }
        }
    }

    /// Adds a file or binary data to the multipart form
    /// - Parameters:
    ///   - key: Form field name
    ///   - value: Binary data to upload
    ///   - fileName: Name of the file being uploaded
    ///   - contentType: MIME type of the file (defaults to application/octet-stream)
    public mutating func addBodyParameter(
        key: String,
        value: Data,
        fileName: String,
        contentType: ContentType = .applicationOctetStream
    ) {
        addBody(
            key: key,
            value: value,
            fileName: fileName,
            contentType: contentType
        )
    }

    /// Adds a text field to the multipart form
    /// - Parameters:
    ///   - key: Form field name
    ///   - value: Text value
    ///   - contentType: MIME type of the text (defaults to text/plain)
    public mutating func addBodyParameter(
        key: String,
        value: String,
        contentType: ContentType = .textPlain
    ) {
        addBody(
            key: key,
            value: Data(value.utf8),
            contentType: contentType
        )
    }

    /// Adds multiple text fields to the multipart form
    /// - Parameter parameters: Dictionary of field names and values
    public mutating func addBodyParameters(
        contentsOf parameters: [String: String]
    ) {
        for (key, value) in parameters {
            addBody(
                key: key,
                value: Data(value.utf8),
                contentType: .textPlain
            )
        }
    }

    /// Internal helper to add a form part with proper boundaries and headers
    /// - Parameters:
    ///   - key: Form field name
    ///   - value: Data to add
    ///   - fileName: Optional filename for file uploads
    ///   - contentType: MIME type of the content
    private mutating func addBody(
        key: String,
        value: Data,
        fileName: String? = nil,
        contentType: ContentType
    ) {
        data.append("--\(boundary)\(separator)")
        data.append("\(contentDisposition)\"\(key)\"")
        if let fileName {
            data.append("; filename=\"\(fileName)\"")
        }
        data.append(separator)
        data.append("Content-Type: \(contentType)")
        data.append("\(separator)\(separator)")
        data.append(value)
        data.append(separator)
    }
}
