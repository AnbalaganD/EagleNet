# File Download

⬇️ Download files directly to your device with memory-safe operations.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Basic File Download

Downloads a file from a remote server directly to the specified local directory. 
By writing directly to disk, EagleNet avoids memory-bloat issues when handling large files.

```swift
let destinationURL = URL(fileURLWithPath: "/path/to/downloads")

let (localURL, response) = try await EagleNet.download(
    url: "https://example.com/large-file.zip",
    destinationDirectory: destinationURL
)

print("File saved successfully to: \(localURL.path)")
```

## Download with Progress Tracking

You can monitor download progress in real-time by providing a `progress` closure:

```swift
let destinationURL = URL(fileURLWithPath: "/path/to/downloads")

let (localURL, response) = try await EagleNet.download(
    url: "https://example.com/movie.mp4",
    destinationDirectory: destinationURL,
    progress: { bytesDownloaded, totalBytes in
        let progress = Float(bytesDownloaded) / Float(totalBytes)
        print("Download progress: \(Int(progress * 100))%")
        
        DispatchQueue.main.async {
            // Update UI progress indicator safely on the main thread
        }
    }
)
```

## Advanced Requests

If you need to pass headers or custom query parameters, the `download` API fully supports them:

```swift
let destinationURL = URL(fileURLWithPath: "/path/to/downloads")

let (localURL, response) = try await EagleNet.download(
    url: "https://api.example.com/secure/report.pdf",
    headers: [
        "Authorization": "Bearer your-token",
        "Accept": "application/pdf"
    ],
    parameters: [
        "quality": "high",
        "watermark": "true"
    ],
    destinationDirectory: destinationURL,
    fileName: "Quarterly_Report_2024.pdf" // Specify a custom filename
)
```

## Important Limitations

When utilizing EagleNet's `download` APIs, please be aware of the following current limitations:

- **No Background Downloads**: Background downloading is currently **not supported**. If your application is suspended, sent to the background, or terminated by the OS, the active download will be cancelled.
- **No Pause/Resume**: EagleNet does not currently support pausing and resuming partial downloads. If a download is interrupted, it must be restarted from the beginning.
