//
//  MBPersistentContainer.swift
//  Mindbox
//
//  Created by Maksim Kazachkov on 29.03.2021.
//  Copyright © 2021 Mindbox. All rights reserved.
//

import Foundation
import CoreData

public class MBPersistentContainer: NSPersistentContainer {
    
    public static var applicationGroupIdentifier: String? = nil
        
    public override class func defaultDirectoryURL() -> URL {
        guard let applicationGroupIdentifier = applicationGroupIdentifier else {
            return super.defaultDirectoryURL()
        }
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: applicationGroupIdentifier) ?? super.defaultDirectoryURL()
    }
    
}
