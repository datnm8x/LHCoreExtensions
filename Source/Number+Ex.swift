//
//  Number+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

public extension Int {
    func toString(separator: String? = nil) -> String {
        let format = NumberFormatter()
        if let gSeparator = separator {
            format.groupingSeparator = gSeparator
            format.numberStyle = .decimal
            format.usesGroupingSeparator = true
        }
        return format.string(for: self) ?? String(self)
    }

    var int64Value: Int64 { return Int64(self) }
}

public extension Int64 {
    func toString(separator: String? = nil) -> String {
        let format = NumberFormatter()
        if let gSeparator = separator {
            format.groupingSeparator = gSeparator
            format.numberStyle = .decimal
            format.usesGroupingSeparator = true
        }
        return format.string(for: self) ?? String(self)
    }

    var intValue: Int { return Int(self) }
}

public extension UIEdgeInsets {
    var inverted: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}
