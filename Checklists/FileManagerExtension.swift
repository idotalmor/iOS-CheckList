//
//  FileManagerExtension.swift
//  Checklists
//
//  Created by Ido Talmor on 02/12/2018.
//  Copyright © 2018 Ido Talmor. All rights reserved.
//

import Foundation

public extension FileManager {
    static var documentDirectoryURL: URL {
        return try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}
