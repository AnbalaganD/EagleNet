//
//  EagleNet+Interceptor.swift
//  EagleNet
//
//  Created by Anbalagan on 16/07/25.
//

extension EagleNet {
    /// Adds an interceptor to modify requests before they are sent
    /// - Parameter interceptor: The request interceptor to add
    @EagleNetActor public func addRequestInterceptor(_ interceptor: any RequestInterceptor) {
        networkService.addRequestInterceptor(interceptor)
    }

    /// Adds an interceptor to modify responses before they are decoded
    /// - Parameter interceptor: The response interceptor to add
    @EagleNetActor public func addResponseInterceptor(_ interceptor: any ResponseInterceptor) {
        networkService.addResponseInterceptor(interceptor)
    }
    
    /// Adds an interceptor to modify requests before they are sent
    /// - Parameter interceptor: The request interceptor to add
    @EagleNetActor public static func addRequestInterceptor(_ interceptor: any RequestInterceptor) {
        shared.addRequestInterceptor(interceptor)
    }

    /// Adds an interceptor to modify responses before they are decoded
    /// - Parameter interceptor: The response interceptor to add
    @EagleNetActor public static func addResponseInterceptor(_ interceptor: any ResponseInterceptor) {
        shared.addResponseInterceptor(interceptor)
    }
}
