//
//  NetworkService.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A protocol that defines the core networking capabilities for making HTTP requests.
///
/// NetworkService provides a centralized way to handle network requests with support for:
/// - Async/await based networking
/// - Request/Response interceptors
/// - File uploads with progress tracking
/// - File downloading direct-to-disk
/// - JSON encoding/decoding
///
/// Example usage:
/// ```swift
/// let service = EagleNet.defaultService(
///     urlSession: .shared,
///     jsonEncoder: JSONEncoder(),
///     jsonDecoder: JSONDecoder(),
///     fileManager: .default
/// )
///
/// // Add interceptors if needed
/// service.addRequestInterceptor(AuthInterceptor(token: "token123"))
///
/// // Make network requests
/// let response: User = try await service.execute(userRequest)
/// ```
public protocol NetworkService: Sendable {
    /// Creates a new network service instance
    /// - Parameters:
    ///   - urlSession: URLSession instance for making network requests
    ///   - jsonEncoder: Encoder for request body serialization
    ///   - jsonDecoder: Decoder for response deserialization
    init(
        urlSession: URLSession,
        jsonEncoder: JSONEncoder,
        jsonDecoder: JSONDecoder,
        fileManager: FileManager
    )

    /// Executes a network request and returns the decoded response
    /// - Parameter request: The request to execute
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the request fails or response cannot be decoded
    func execute<Response: Decodable>(_ request: any NetworkRequestable) async throws -> Response

    /// Executes a network request and returns raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``execute(_:)->Response`` for the decoded response variant.
    /// 
    /// - Parameter request: The request to execute
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the request fails
    func execute(_ request: any NetworkRequestable) async throws -> (Data, URLResponse)

    /// Uploads data with progress tracking
    /// - Parameters:
    ///   - request: The upload request to execute
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the upload fails or response cannot be decoded
    func upload<Response: Decodable>(
        _ request: any NetworkRequestable,
        progress: ProgressHandler?
    ) async throws -> Response

    /// Uploads data with progress tracking and returns raw data and response
    /// 
    /// This overload returns the raw response Data and URLResponse instead of decoding to a specific type.
    /// Use this when you need access to the raw response data or response metadata.
    /// 
    /// See ``upload(_:progress:)->Response`` for the decoded response variant.
    /// 
    /// - Parameters:
    ///   - request: The upload request to execute
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Tuple containing raw response Data and URLResponse
    /// - Throws: NetworkError if the upload fails
    func upload(
        _ request: any NetworkRequestable,
        progress: ProgressHandler?
    ) async throws -> (Data, URLResponse)
    
    /// Downloads a file to a specified local directory
    ///
    /// This method performs an HTTP request and carefully writes the response data
    /// directly to the specified destination directory to avoid excessive memory usage.
    ///
    /// > Note: Background downloads are currently **not supported** by this library.
    ///
    /// ## Usage Example
    /// ```swift
    /// let (localURL, response) = try await service.download(
    ///     request,
    ///     destinationDirectory: downloadsFolder,
    ///     progress: { bytesDownloaded, totalBytes in
    ///         let percentage = (Double(bytesDownloaded) / Double(totalBytes)) * 100
    ///         print(String(format: "Downloading: %.1f%%", percentage))
    ///     }
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - request: The download request to execute
    ///   - location: The local directory URL where the file should be saved. Must be a directory URL.
    ///   - fileName: Optional custom local file name. If omitted, uses the server's suggested name or a generated UUID.
    ///   - progress: Optional closure to track download progress. Provides bytes downloaded and total expected bytes.
    /// - Returns: Tuple containing the URL of the saved file and the URLResponse
    /// - Throws: NetworkError if the download fails or the destination is invalid
    func download(
        _ request: any NetworkRequestable,
        destinationDirectory location: any URLConvertible,
        fileName: String?,
        progress: ProgressHandler?
    ) async throws -> (URL, URLResponse)

    /// Adds an interceptor to modify requests before they are sent
    /// - Parameter interceptor: The request interceptor to add
    func addRequestInterceptor(_ interceptor: any RequestInterceptor)

    /// Adds an interceptor to modify responses before they are decoded
    /// - Parameter interceptor: The response interceptor to add
    func addResponseInterceptor(_ interceptor: any ResponseInterceptor)
}

final class DefaultNetworkService: NetworkService, @unchecked Sendable {
    private let urlSession: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private let fileManager: FileManager

    private var requestInterceptors = [any RequestInterceptor]()
    private var responseInterceptors = [any ResponseInterceptor]()

    required init(
        urlSession: URLSession = .shared,
        jsonEncoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init(),
        fileManager: FileManager = .default
    ) {
        self.urlSession = urlSession
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
        self.fileManager = fileManager
    }

    func execute<Response: Decodable>(_ request: any NetworkRequestable) async throws -> Response {
        let result = try await execute(request)
        return try handleResponse(data: result.0, response: result.1)
    }

    func execute(_ request: any NetworkRequestable) async throws -> (Data, URLResponse) {
        var urlRequest = try buildRequest(from: request)

        urlRequest = try await requestInterceptors.reduce(urlRequest) { result, interceptor in
            try await interceptor.modify(request: result)
        }

        let result = try await urlSession.data(for: urlRequest)

        return try await responseInterceptors.reduce(result) { result, interceptor in
            try await interceptor.modify(data: result.0, urlResponse: result.1)
        }
    }

    func upload<Response: Decodable>(
        _ request: any NetworkRequestable,
        progress: ProgressHandler? = nil
    ) async throws -> Response {
        let result = try await upload(request, progress: progress)
        return try handleResponse(data: result.0, response: result.1)
    }

    func upload(
        _ request: any NetworkRequestable,
        progress: ProgressHandler?
    ) async throws -> (Data, URLResponse) {
        var urlRequest = try buildRequest(from: request)

        urlRequest = try await requestInterceptors.reduce(urlRequest) { result, interceptor in
            try await interceptor.modify(request: result)
        }

        let bodyData = urlRequest.httpBody ?? Data()
        urlRequest.httpBody = nil
        let result = try await urlSession.upload(
            for: urlRequest,
            from: bodyData,
            delegate: SessionDelegate(uploadProgress: progress)
        )

        return try await responseInterceptors.reduce(result) { result, interceptor in
            try await interceptor.modify(data: result.0, urlResponse: result.1)
        }
    }
    
    func download(
        _ request: any NetworkRequestable,
        destinationDirectory location: any URLConvertible,
        fileName: String? = nil,
        progress: ProgressHandler? = nil
    ) async throws -> (URL, URLResponse) {
        var urlRequest = try buildRequest(from: request)

        urlRequest = try await requestInterceptors.reduce(urlRequest) { result, interceptor in
            try await interceptor.modify(request: result)
        }
        
        let result = try await urlSession.download(
            for: urlRequest,
            delegate: SessionDelegate(downloadProgress: progress)
        )
        
        let (url, response) = try await responseInterceptors.reduce(result) { result, interceptor in
            try await interceptor.modify(url: result.0, urlResponse: result.1)
        }
        
        if let httpURLResponse = response as? HTTPURLResponse,
              !httpURLResponse.isSuccess {
            throw NetworkError.failure(
                message: httpURLResponse.description,
                statusCode: httpURLResponse.statusCode,
                data: nil
            )
        }

        return try handleDownloadResponse(
            url: url,
            response: response,
            destinationDirectory: location,
            fileName: fileName
        )
    }

    func addRequestInterceptor(_ interceptor: any RequestInterceptor) {
        requestInterceptors.append(interceptor)
    }

    func addResponseInterceptor(_ interceptor: any ResponseInterceptor) {
        responseInterceptors.append(interceptor)
    }

    private func buildRequest(
        from request: any NetworkRequestable
    ) throws -> URLRequest {
        let url = try getRequestURL(request)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue

        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil,
           let contentType = request.contentType?.rawValue {
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        if let bodyValue = request.body {
            urlRequest.httpBody = try bodyValue as? Data ?? jsonEncoder.encode(bodyValue)
        }

        return urlRequest
    }

    private func getRequestURL(_ request: any NetworkRequestable) throws -> URL {
        let url = try request.url.asURL()

        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        if let path = request.path {
            urlComponents.path += path
        }

        let queryItems: [URLQueryItem] = request.parameters?.map {
            .init(name: $0.key, value: $0.value)
        } ?? []

        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

        guard let constructedURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        return constructedURL
    }

    private func handleResponse<Response: Decodable>(
        data: Data,
        response: URLResponse
    ) throws -> Response {
        if let httpURLResponse = response as? HTTPURLResponse,
              !httpURLResponse.isSuccess {
            throw NetworkError.failure(
                message: httpURLResponse.description,
                statusCode: httpURLResponse.statusCode,
                data: data
            )
        }

        do {
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            let rawString = String(data: data, encoding: .utf8) ?? ""
            throw NetworkError.parsingError(error: error, raw: rawString)
        }
    }
    
    private func handleDownloadResponse(
        url: URL,
        response: URLResponse,
        destinationDirectory location: any URLConvertible,
        fileName: String? = nil
    ) throws -> (URL, URLResponse) {
        let storedPath = try location.asURL()
        guard storedPath.isFileURL else {
            throw NetworkError.invalidFileURL(
                message: "`destinationDirectory` should be local file URL"
            )
        }
        
        guard storedPath.hasDirectoryPath else {
            throw NetworkError.invalidFileURL(
                message: "`destinationDirectory` should be point to `directory` not a file"
            )
        }
        
        if !fileManager.fileExists(atPath: storedPath.path) {
            try fileManager.createDirectory(at: storedPath, withIntermediateDirectories: true)
        }
        
        let name = fileName ?? response.suggestedFilename ?? "unknown_\(UUID().uuidString)"
        let downloadLocation = storedPath.appendingPathComponent(name)
        
        if fileManager.fileExists(atPath: downloadLocation.path) {
            try fileManager.removeItem(at: downloadLocation)
        }
        try fileManager.moveItem(at: url, to: downloadLocation)
        
        return (downloadLocation, response)
    }
}
