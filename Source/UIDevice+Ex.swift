//
//  UIDevice+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    static var isRabbitEar: Bool {
        if #available(iOS 11.0, *) {
            var safeAreaTop = (UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0)
            safeAreaTop -= UIApplication.shared.isStatusBarHidden ? 0 : 20
            return safeAreaTop > 0
        }
        return false
    }
    
    static var height: CGFloat { return UIScreen.height }
    static var width: CGFloat { return UIScreen.width }
    
    static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
        } else {
            var layoutMargins = UIApplication.shared.windows.first?.layoutMargins ?? UIEdgeInsets.zero
            layoutMargins.top -= (layoutMargins.left + layoutMargins.right) / 2
            layoutMargins.bottom -= (layoutMargins.left + layoutMargins.right) / 2
            layoutMargins.left = 0
            layoutMargins.right = 0
            return layoutMargins
        }
    }
}

public extension UIScreen {
    static var height: CGFloat { return self.main.bounds.size.height }
    static var width: CGFloat { return self.main.bounds.size.width }
}
