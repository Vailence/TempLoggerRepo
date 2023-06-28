//
//  ValidationError.swift
//  MindboxLogger
//
//  Created by vailence on 28.06.2023.
//  Copyright © 2023 Mindbox. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "This enum is deprecated. Do not use MindboxLogger.ValidationError at all.")
public struct ValidationError: Codable, CustomStringConvertible {
    public let status: Status
    /// Array of validation problems
    public let validationMessages: [ValidationMessage]

    public var description: String {
        return validationMessages.map { "Field \($0.location ?? "no location") error. Message: \($0.message ?? "no message")" }.joined(separator: ";\n")
    }
}

@available(*, deprecated, message: "This enum is deprecated. Do not use MindboxLogger.ValidationMessage at all.")
public struct ValidationMessage: Codable {
    /// Message for specified field
    public let message: String?
    /// Location of field
    public let location: String?
}

