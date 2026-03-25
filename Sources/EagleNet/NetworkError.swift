//
//  NetworkError.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

/// Represents errors that can occur during network operations
/// 
/// This enum defines the different types of errors that can occur when making
/// network requests with EagleNet, including HTTP errors and parsing failures.
/// 
/// ## Example Usage
/// ```swift
/// do {
///     let user: User = try await EagleNet.get(url: "https://api.example.com/users/1")
///     // Process successful response
/// } catch let error as NetworkError {
///     switch error {
///     case .failure(let message, let statusCode, let data):
///         print("Network error: \(message), status code: \(statusCode)")
///         if let errorData = data {
///             print("Response data: \(String(data: errorData, encoding: .utf8) ?? "Invalid data")")
///         }
///     case .parsingError(let error, let raw):
///         print("Failed to parse response:\nUnderlying Error: \(error) \nRaw Response: \(raw)")
///     }
/// } catch {
///     print("Unexpected error: \(error)")
/// }
/// ```
public enum NetworkError: Error {
    /// Represents an HTTP request failure
    /// - Parameters:
    ///   - message: Description of the error
    ///   - statusCode: HTTP status code
    ///   - data: Optional raw response data for debugging or custom error parsing
    case failure(message: String, statusCode: Int, data: Data?)

    /// Represents an error that occurred during response parsing
    /// - Parameters:
    ///   - error: The underlying parsing error
    ///   - raw: The raw JSON string that was sent to the decoder
    case parsingError(error: any Error, raw: String)

    /// Indicates that the provided value could not be converted to a valid URL
    case invalidURL
    
    /// Indicates that the provided location is not a local `file://` URL.
    case invalidFileURL

    /// Indicates that a directory path was expected, but the provided path points to a file.
    case invalidDirectoryPath
}

extension NetworkError: CustomStringConvertible, CustomDebugStringConvertible {
    /// Human-readable description of the network error
    public var description: String {
        return switch self {
        case .failure(message: let message, statusCode: let statusCode, _):
            "Network request failure.\nMessage: \(message)\nStatus Code: \(statusCode)"
        case .parsingError(error: let error, raw: let raw):
            "Error while parsing the response:\nUnderlying Error: \(error)\nRaw Response: \(raw)"
        case .invalidURL: "Invalid request URL"
        case .invalidFileURL:
            "Local File Error: Expected a local file URL"
        case .invalidDirectoryPath:
            "Local File Error: Expected a directory path, not a file"
        }
    }

    /// Debug description (same as description for NetworkError)
    public var debugDescription: String { description }
}
