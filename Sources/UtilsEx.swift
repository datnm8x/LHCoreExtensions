//
//  UtilsEx.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm. All rights reserved.
//

import Foundation

public func DebugLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    // to use this, you must sure that: "-D DEBUG added to "Other Swift Flags" in your target's Build Settings at Debug mode
    #if DEBUG
    for index in 0...(items.endIndex - 1) {
        if index == (items.endIndex - 1) {
            print(items[index], separator: separator, terminator: terminator)
        } else {
            print(items[index], separator: separator, terminator: separator)
        }
    }
    #endif
}

public func LocalizedString(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
}
