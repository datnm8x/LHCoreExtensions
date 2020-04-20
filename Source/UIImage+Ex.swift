//
//  UIImage+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
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

    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    convenience init?(named: String, ofType: String? = "png", inBundle: Bundle? = Bundle.main) {
        guard let path = (inBundle ?? Bundle.main).path(forResource: named, ofType: ofType) else { return nil }
        self.init(contentsOfFile: path)
    }
}
