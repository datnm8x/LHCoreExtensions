//
//  UIColor+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac). All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     - parameter hex6: Six-digit hexadecimal value.
     */
    convenience init(hexCss rgb: UInt32, alpha alph: CGFloat = 1.0) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / CGFloat(255)
        let green = CGFloat((rgb & 0x00FF00) >> 8) / CGFloat(255)
        let blue = CGFloat( rgb & 0x0000FF) / CGFloat(255)
        self.init(red: red, green: green, blue: blue, alpha: alph)
    }
}
