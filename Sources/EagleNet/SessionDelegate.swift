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

final class SessionDelegate: NSObject, URLSessionTaskDelegate {
    private let progress: ProgressHandler?
    init(progress: ProgressHandler?) {
        self.progress = progress
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        progress?(totalBytesSent, totalBytesExpectedToSend)
    }
}
