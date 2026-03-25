//
//  EagleNet+Download.swift
//  EagleNet
//
//  Created by Anbalagan on 20/02/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension EagleNet {
    /// Downloads a file from the specified URL to a local directory.
    ///
    /// This method performs an HTTP request and downloads the response data directly to a file
    /// in the specified `destinationDirectory`. It is useful for downloading large files as it
    /// writes directly to disk, avoiding memory pressure.
    ///
    /// > Note: Background downloads are currently **not supported**. Downloads will be
    /// > cancelled if the application goes into the background or is terminated.
    ///
    /// ## Basic Usage
    /// ```swift
    /// let (localURL, response) = try await EagleNet.download(
    ///     url: "https://example.com/large-file.zip",
    ///     destinationDirectory: URL(fileURLWithPath: "/path/to/downloads")
    /// )
    /// print("File downloaded successfully to: \(localURL.path)")
    /// ```
    ///
    /// ## Usage with Progress Tracking
    /// ```swift
    /// let (localURL, response) = try await EagleNet.download(
    ///     url: "https://example.com/movie.mp4",
    ///     destinationDirectory: URL(fileURLWithPath: "/path/to/downloads"),
    ///     progress: { bytesDownloaded, totalBytes in
    ///         let progress = Float(bytesDownloaded) / Float(totalBytes)
    ///         print("Download progress: \(Int(progress * 100))%")
    ///     }
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - url: The base URL for the download request.
    ///   - path: Optional path to append to the URL.
    ///   - httpMethod: The HTTP method for the request. Defaults to `.get`.
    ///   - headers: Optional HTTP headers.
    ///   - parameters: Optional query parameters.
    ///   - body: Optional request body (any Encodable type or Data).
    ///   - location: The local directory URL where the file should be saved. It must resolve to a local `file://` URL and point to a directory.
    ///   - fileName: Optional custom file name for the downloaded file. If `nil`, a suggested filename from the response or a generated UUID will be used.
    ///   - progress: Optional closure to track download progress. Provides bytes downloaded and total expected bytes.
    /// - Returns: A tuple containing the local `URL` where the file was saved and the `URLResponse`.
    /// - Throws: `NetworkError.invalidFileURL` if `location` does not resolve to a local `file://` URL,
    ///   `NetworkError.invalidDirectoryPath` if `location` points to a file instead of a directory,
    ///   or another `NetworkError` if the request or file operation fails.
    public static func download(
        url: any URLConvertible,
        path: String? = nil,
        httpMethod: HTTPMethod = .get,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: Body? = nil,
        destinationDirectory location: any URLConvertible,
        fileName: String? = nil,
        progress: ProgressHandler? = nil
    ) async throws -> (URL, URLResponse) {
        try await networkService.download(
            DataRequest(
                url: url,
                path: path,
                httpMethod: httpMethod,
                headers: headers,
                parameters: parameters,
                body: body
            ),
            destinationDirectory: location,
            fileName: fileName,
            progress: progress
        )
    }
}
