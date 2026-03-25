//
//  SessionDelegate.swift
//  EagleNet
//
//  Created by Anbalagan on 09/01/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class SessionDelegate: NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    private let uploadProgress: ProgressHandler?
    private let downloadProgress: ProgressHandler?

    init(
        uploadProgress: ProgressHandler? = nil,
        downloadProgress: ProgressHandler? = nil
    ) {
        self.uploadProgress = uploadProgress
        self.downloadProgress = downloadProgress
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        uploadProgress?(totalBytesSent, totalBytesExpectedToSend)
    }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) { }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        downloadProgress?(totalBytesWritten, totalBytesExpectedToWrite)
    }
}
