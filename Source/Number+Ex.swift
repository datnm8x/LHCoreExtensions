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
}
