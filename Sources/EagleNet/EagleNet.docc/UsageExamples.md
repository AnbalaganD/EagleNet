# Usage Examples

📚 Real-world examples of using EagleNet.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Complete User Management Example

```swift
import EagleNet

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

struct CreateUserRequest: Encodable {
    let name: String
    let email: String
}

class UserService {
    
    init() {
        // Optional: Configure custom network service only if you need advanced settings
        // Otherwise, EagleNet uses sensible defaults
        /*
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        
        let customService = EagleNet.defaultService(
            urlSession: URLSession(configuration: configuration),
            jsonEncoder: JSONEncoder(),
            jsonDecoder: JSONDecoder(),
            fileManager: .default
        )
        
        EagleNet.configure(networkService: customService)
        */
        
        // Setup authentication
        EagleNet.addRequestInterceptor(
            AuthInterceptor(token: "your-auth-token")
        )
        
        // Setup logging
        EagleNet.addResponseInterceptor(LoggingInterceptor())
    }
    
    func getUser(id: Int) async throws -> User {
        return try await EagleNet.get(
            url: "https://api.example.com/users/\(id)"
        )
    }
    
    func createUser(name: String, email: String) async throws -> User {
        let request = CreateUserRequest(name: name, email: email)
        return try await EagleNet.post(
            url: "https://api.example.com/users",
            body: request
        )
    }
    
    func updateUser(_ user: User) async throws -> User {
        return try await EagleNet.put(
            url: "https://api.example.com/users/\(user.id)",
            body: user
        )
    }
    
    func deleteUser(id: Int) async throws {
        try await EagleNet.delete(
            url: "https://api.example.com/users/\(id)"
        )
    }
}
```

## File Upload with Progress

```swift
import SwiftUI
import EagleNet

struct FileUploadView: View {
    @State private var uploadProgress: Float = 0
    @State private var isUploading = false
    
    var body: some View {
        VStack {
            if isUploading {
                ProgressView(value: uploadProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                Text("\(Int(uploadProgress * 100))% uploaded")
            }
            
            Button("Upload Image") {
                uploadImage()
            }
            .disabled(isUploading)
        }
    }
    
    private func uploadImage() {
        guard let imageData = UIImage(named: "sample")?.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        isUploading = true
        
        Task {
            do {
                let response: UploadResponse = try await EagleNet.upload(
                    url: "https://api.example.com/upload",
                    parameters: [
                        .file(
                            key: "image",
                            fileName: "photo.jpg",
                            data: imageData,
                            mimeType: .jpegImage
                        )
                    ],
                    progress: { bytesTransferred, totalBytes in
                        DispatchQueue.main.async {
                            self.uploadProgress = Float(bytesTransferred) / Float(totalBytes)
                        }
                    }
                )
                
                print("Upload successful: \(response)")
            } catch {
                print("Upload failed: \(error)")
            }
            
            DispatchQueue.main.async {
                self.isUploading = false
                self.uploadProgress = 0
            }
        }
    }
}
```

## File Download with Progress

```swift
import SwiftUI
import EagleNet

struct FileDownloadView: View {
    @State private var downloadProgress: Float = 0
    @State private var isDownloading = false
    @State private var downloadedFileURL: URL?
    
    // Directory where the file will be saved
    private var downloadsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if isDownloading {
                ProgressView(value: downloadProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                Text("\(Int(downloadProgress * 100))% downloaded")
            }
            
            if let downloadedFileURL = downloadedFileURL {
                Text("Saved to:")
                    .font(.caption)
                Text(downloadedFileURL.lastPathComponent)
                    .bold()
            }
            
            Button(isDownloading ? "Downloading..." : "Download Large Video") {
                downloadVideo()
            }
            .disabled(isDownloading)
            .buttonStyle(.borderedProminent)
            
            Text("Note: Background downloading is not currently supported. Keep app active.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func downloadVideo() {
        isDownloading = true
        downloadedFileURL = nil
        
        Task {
            do {
                let (localURL, _) = try await EagleNet.download(
                    url: "https://api.example.com/videos/tutorial_hd.mp4",
                    destinationDirectory: downloadsDirectory,
                    fileName: "tutorial_hd.mp4",
                    progress: { bytesDownloaded, totalBytes in
                        DispatchQueue.main.async {
                            self.downloadProgress = Float(bytesDownloaded) / Float(totalBytes)
                        }
                    }
                )
                
                DispatchQueue.main.async {
                    self.downloadedFileURL = localURL
                    print("Download successful! Saved at: \(localURL.path)")
                }
            } catch let error as NetworkError {
                switch error {
                case .invalidFileURL:
                    print("Download failed: destination must be a local file URL")
                case .invalidDirectoryPath:
                    print("Download failed: destination must be a directory")
                default:
                    print("Download failed: \(error)")
                }
            } catch {
                print("Download failed: \(error)")
            }
            
            DispatchQueue.main.async {
                self.isDownloading = false
                self.downloadProgress = 0
            }
        }
    }
}
```

## API Client with Error Handling

```swift
class APIClient {
    private let baseURL = "https://api.example.com"
    
    init() {
        setupInterceptors()
    }
    
    private func setupInterceptors() {
        EagleNet.addRequestInterceptor(AuthInterceptor(token: getAuthToken()))
        EagleNet.addResponseInterceptor(ErrorLoggingInterceptor())
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil
    ) async throws -> T {
        let url = "\(baseURL)\(endpoint)"
        
        do {
            switch method {
            case .get:
                return try await EagleNet.get(url: url)
            case .post:
                return try await EagleNet.post(url: url, body: body)
            case .put:
                return try await EagleNet.put(url: url, body: body)
            case .delete:
                try await EagleNet.delete(url: url)
                return EmptyResponse() as! T
            }
        } catch NetworkError.failure(let message, let statusCode, let data) {
            throw APIError.httpError(statusCode, data)
        } catch NetworkError.parsingError(let error, let raw) {
            throw APIError.parsingError(error)
        } catch NetworkError.invalidURL {
            throw APIError.invalidURL
        } catch {
            throw APIError.networkError(error)
        }
    }
}
```
