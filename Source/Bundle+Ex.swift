//
//  Bundle+Ex.swift
//  LHCoreExtensions iOS
//
//  Created by Nguyen Mau Dat on 4/24/20.
//  Copyright © 2020 Lao Hac. All rights reserved.
//

import Foundation

public extension Bundle {
    static func stringValue(_ key: String) -> String? {
        return Bundle.main.infoDictionary?[key] as? String
    }
    
    static var shortVersion: String {
        stringValue("CFBundleShortVersionString") ?? ""
    }
}
