//
//  HTTPMethod.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

public struct HTTPMethod: RawRepresentable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let get = HTTPMethod(rawValue: "GET")

    public static let post = HTTPMethod(rawValue: "POST")

    public static let put = HTTPMethod(rawValue: "PUT")

    public static let delete = HTTPMethod(rawValue: "DELETE")
}
