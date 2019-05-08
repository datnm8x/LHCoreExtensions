//
//  UIDevice+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac). All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    static var isRabbitEar: Bool {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0) > 0
        }
        return false
    }
    
    static var height: CGFloat { return UIScreen.height }
    static var width: CGFloat { return UIScreen.width }
}

public extension UIScreen {
    static var height: CGFloat { return self.main.bounds.size.height }
    static var width: CGFloat { return self.main.bounds.size.width }
}
