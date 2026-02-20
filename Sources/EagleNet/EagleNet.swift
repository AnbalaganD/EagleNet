//
//  EagleNet.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// EagleNet is a lightweight networking library built on top of URLSession.
///
/// This library provides a simple and elegant approach to writing network requests,
/// with a focus on being lightweight, maintainable, and beginner-friendly.
///
/// ## Features
/// - Basic HTTP data requests (GET, POST, PUT, DELETE)
/// - File uploads using multipart/form-data
/// - Request and response interceptors
/// - Async/await based API
///
/// ## Basic Usage
/// ```swift
/// // GET request
/// let user: User = try await EagleNet.get(
///     url: "https://api.example.com/users/1"
/// )
///
/// // POST request
/// let newUser = CreateUser(name: "Anbalagan D", email: "anbu94p@gmail.com")
/// let response: UserResponse = try await EagleNet.post(
///     url: "https://api.example.com/users",
///     body: newUser
/// )
///
/// // File upload
/// let response: UploadResponse = try await EagleNet.upload(
///     url: "https://api.example.com/upload",
///     parameters: [
///         .file(
///             key: "avatar",
///             fileName: "profile.jpg",
///             data: imageData,
///             mimeType: .jpegImage
///         ),
///         .text(key: "username", value: "Anbu")
///     ],
///     progress: { bytesTransferred, totalBytes in
///         let progress = Float(bytesTransferred) / Float(totalBytes)
///         print("Upload progress: \(Int(progress * 100))%")
///     }
/// )
/// ```
public enum EagleNet {
    /// The underlying network service that handles all requests
    @EagleNetActor
    static var networkService: any NetworkService = DefaultNetworkService()

    /// Configures EagleNet with a custom network service implementation.
    ///
    /// This method allows you to replace the default NetworkService with a custom implementation,
    /// enabling advanced configurations like custom URLSession settings, mock services for testing,
    /// or specialized networking behavior.
    ///
    /// - Parameter networkService: The custom NetworkService implementation to use
    ///
    /// ## Usage Examples
    ///
    /// ### Custom URLSession Configuration
    /// ```swift
    /// let configuration = URLSessionConfiguration.default
    /// configuration.timeoutIntervalForRequest = 30
    /// configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    ///
    /// let customService = EagleNet.defaultService(
    ///     urlSession: URLSession(configuration: configuration),
    ///     jsonEncoder: JSONEncoder(),
    ///     jsonDecoder: JSONDecoder()
    /// )
    ///
    /// EagleNet.configure(networkService: customService)
    /// ```
    ///
    /// ### Mock Service for Testing
    /// ```swift
    /// let mockService = MockNetworkService()
    /// EagleNet.configure(networkService: mockService)
    /// ```
    ///
    /// - Important: Call this method before making any network requests to ensure
    ///   the custom configuration is applied consistently.
    @EagleNetActor
    public static func configure(networkService: any NetworkService) {
        EagleNet.networkService = networkService
    }

    /// Creates a default network service with optional custom configuration
    ///
    /// This factory method provides a convenient way to create a NetworkService instance
    /// with custom URLSession configuration, JSON encoders, or decoders.
    ///
    /// - Parameters:
    ///   - urlSession: URLSession to use for network requests (defaults to .shared)
    ///   - jsonEncoder: JSON encoder for serializing request bodies (defaults to JSONEncoder())
    ///   - jsonDecoder: JSON decoder for deserializing responses (defaults to JSONDecoder())
    ///   - fileManager: FileManager to use for file operations like downloads (defaults to .default)
    /// - Returns: Configured NetworkService instance
    ///
    /// ## Usage Examples
    ///
    /// ### Basic Usage
    /// ```swift
    /// let service = EagleNet.defaultService()
    /// EagleNet.configure(networkService: service)
    /// ```
    ///
    /// ### Custom Configuration
    /// ```swift
    /// let configuration = URLSessionConfiguration.default
    /// configuration.timeoutIntervalForRequest = 60
    ///
    /// let encoder = JSONEncoder()
    /// encoder.dateEncodingStrategy = .iso8601
    ///
    /// let service = EagleNet.defaultService(
    ///     urlSession: URLSession(configuration: configuration),
    ///     jsonEncoder: encoder
    /// )
    /// EagleNet.configure(networkService: service)
    /// ```
    public static func defaultService(
        urlSession: URLSession = .shared,
        jsonEncoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init(),
        fileManager: FileManager = .default
    ) -> any NetworkService {
        DefaultNetworkService(
            urlSession: urlSession,
            jsonEncoder: jsonEncoder,
            jsonDecoder: jsonDecoder,
            fileManager: fileManager
        )
    }
}
