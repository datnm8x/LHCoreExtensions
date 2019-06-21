//
//  UtilsEx.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation

public func DebugLogFull(_ items: Any..., separator: String = " ", terminator: String = "\n", filepath: StaticString = #file, function: StaticString = #function, line: Int = #line)
{
    #if DEBUG
    let formatdate = DateFormatter();
    formatdate.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let time = formatdate.string(from: Date())
    let filename = "\(filepath)".lastPathComponent
    let funcName = "\(function)".components(separatedBy: "(").first ?? "\(function)"
    var message = "\(time) [\(filename):\(line)]|\(funcName)->\n-> "
    for index in 0..<items.endIndex {
        print(items[index], separator: separator, terminator: separator, to: &message)
    }
    print(message.stringByDeleteSuffix(separator))
    #endif
}

public func DebugLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    // to use this, you must sure that: "-D DEBUG added to "Other Swift Flags" in your target's Build Settings at Debug mode
    
    #if DEBUG
    let formatdate = DateFormatter()
    formatdate.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let time = formatdate.string(from: Date())
    var message = "\(time) "
    
    for index in 0..<items.endIndex {
        print(items[index], separator: separator, terminator: separator, to: &message)
    }
    print(message.stringByDeleteSuffix(separator))
    #endif
}

public func LocalizedString(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
}
