//
//  Status.swift
//  MindboxLogger
//
//  Created by vailence on 28.06.2023.
//  Copyright © 2023 Mindbox. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "This enum is deprecated. Do not use MindboxLogger.Status at all.")
public enum Status: String, UnknownCodable {
    case success = "Success"
    case validationError = "ValidationError"
    case protocolError = "ProtocolError"
    case internalServerError = "InternalServerError"
    case transactionAlreadyProcessed = "TransactionAlreadyProcessed"
    case unknown
}
