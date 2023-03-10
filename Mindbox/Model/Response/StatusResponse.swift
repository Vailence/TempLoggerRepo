//
//  StatusResponse.swift
//  Mindbox
//
//  Created by Mikhail Plotnikov on 01.07.2021.
//

import Foundation

open class StatusResponse: Codable {
    public let ids: IDS?
    public let dateTimeUtc: DateTime?
}
