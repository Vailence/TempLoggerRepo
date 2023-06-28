//
//  UsedResponse.swift
//  Mindbox
//
//  Created by lbr on 08.06.2021.
//  Copyright © 2021 Mindbox. All rights reserved.
//

import Foundation

open class UsedResponse: Codable {
    public let usageServiceStatus: UsageServiceStatusResponse?
    public let amount: Double?
}
