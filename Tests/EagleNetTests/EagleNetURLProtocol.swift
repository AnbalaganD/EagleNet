//
//  EagleNetURLProtocol.swift
//  EagleNet
//
//  Created by Anbalagan on 18/02/26.
//

import Foundation

class EagleNetURLProtocol: URLProtocol {
    override init(
        request: URLRequest,
        cachedResponse: CachedURLResponse?,
        client: (any URLProtocolClient)?
    ) {
        super.init(
            request: request,
            cachedResponse: cachedResponse,
            client: client
        )
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override func startLoading() {
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        print(#function)
    }
}
