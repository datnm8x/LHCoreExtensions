//
//  UIImage+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac). All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    func maskColor(_ color: UIColor?) -> UIImage {
        guard let color = color else { return self }
        var resultImage = self
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: CGPoint.zero, size: size)
            color.setFill()
            self.draw(in: rect)
            context.setBlendMode(.sourceIn)
            context.fill(rect)
            
            if let imgContext = UIGraphicsGetImageFromCurrentImageContext() { resultImage = imgContext }
        }
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}
