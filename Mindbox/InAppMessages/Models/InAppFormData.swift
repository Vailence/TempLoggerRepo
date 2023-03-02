//
//  InAppMessage.swift
//  Mindbox
//
//  Created by Максим Казаков on 06.09.2022.
//  Copyright © 2022 Mikhail Barilov. All rights reserved.
//

import Foundation

/// Domain model that contains all data needed to show inapp on screen
struct InAppFormData {
    let inAppId: String
    let imageUrl: URL
    let redirectUrl: String
    let intentPayload: String
}
