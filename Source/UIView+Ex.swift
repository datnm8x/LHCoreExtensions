//
//  UIView+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    var xFrame: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var yFrame: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    class var nibNameClass: String? {
        return "\(self)".components(separatedBy: ".").first
    }
    
    class var nib: UINib? {
        if Bundle.main.path(forResource: nibNameClass, ofType: "nib") != nil {
            return UINib(nibName: nibNameClass ?? "", bundle: nil)
        }
        return nil
    }
    
    class func fromNib(nibNameOrNil: String? = nil) -> Self? {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        let nibName = (nibNameOrNil ?? nibNameClass) ?? ""
        guard Bundle.main.path(forResource: nibName, ofType: "nib") != nil else {
            return nil
        }
        
        if let nibViews = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil), nibViews.count > 0 {
            for view in nibViews where view is T {
                return view as? T
            }
        }
        
        return nil
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func captured(withScale: CGFloat = 0.0) -> UIImage? {
        var capturedImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, withScale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: currentContext)
            capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    func rotate(degree: CGFloat = 0, duration: TimeInterval = 0) {
        DispatchQueue.mainAsync { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.transform = CGAffineTransform(rotationAngle: CGFloat.pi * degree / 180.0)
            }
        }
    }
}

@IBDesignable
extension UIView {
    @IBInspectable
    open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get { return layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!) }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @objc public func setCornerRadius(_ radius: CGFloat, width: CGFloat = 0, color: UIColor? = nil) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
        if radius > 0 {
            clipsToBounds = true
        }
    }
    
    @objc public func applySketchShadow(color: UIColor = .black, opacity: Float = 1.0,
                                  x: CGFloat = 0, y: CGFloat = -3, blur: CGFloat = 6, spread: CGFloat = 0)
    {
        layer.applySketchShadow(color: color, opacity: opacity, x: x, y: y, blur: blur, spread: spread)
    }
}

extension CALayer {
    internal func applySketchShadow(
        color: UIColor = .black,
        opacity: Float = 1.0,
        x: CGFloat = 0,
        y: CGFloat = -3,
        blur: CGFloat = 6,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        masksToBounds = false
    }
}
