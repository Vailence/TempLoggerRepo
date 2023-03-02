//
//  InAppResponse.swift
//  Mindbox
//
//  Created by Максим Казаков on 06.09.2022.
//  Copyright © 2022 Mikhail Barilov. All rights reserved.
//

import Foundation

/// Contains information of what in-apps should be shown in the app
struct InAppResponse {
    let triggerEvent: InAppMessageTriggerEvent
    let inAppToShowId: String
}
