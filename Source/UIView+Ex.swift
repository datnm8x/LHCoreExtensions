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
    
    // IBInspectable border UIView
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            setNeedsLayout()
            layer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
            setNeedsLayout()
            layer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let layerCgColor = layer.borderColor {
                return UIColor(cgColor: layerCgColor)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsLayout()
            layer.setNeedsDisplay()
        }
    }
    
    func setCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        clipsToBounds = true
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

public extension CALayer {
    var borderUIColor: UIColor? {
        get {
            if let cgColor = self.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set { borderColor = newValue?.cgColor }
    }
}

@IBDesignable
open class LHCornerView: UIView {
    public enum BorderCorner {
        case <#case#>
    }
    
    @IBInspectable var radiusPercent: CGFloat = 0.5 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable var topLeft: Bool = true
    @IBInspectable var topRight: Bool = true
    @IBInspectable var bottomLeft: Bool = true
    @IBInspectable var bottomRight: Bool = true
    
    @IBInspectable var constantRadius: CGFloat = -1 {
        didSet {
            setCornerRadius()
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        if topLeft && topRight && bottomLeft && bottomRight{
            if constantRadius >= 0 {
                self.layer.cornerRadius = constantRadius
                self.layer.masksToBounds = true
                
            }else{
                self.layer.cornerRadius = self.frame.size.height*CGFloat(radiusPercent)
                self.layer.masksToBounds = true
            }
            
        } else {
            let radii = (constantRadius >= 0 ) ? constantRadius :self.frame.size.height*CGFloat(radiusPercent)
            
            var corners:UInt =  0
            if topLeft {
                corners |= UIRectCorner.topLeft.rawValue
            }
            if topRight {
                corners |= UIRectCorner.topRight.rawValue
            }
            if bottomLeft {
                corners |= UIRectCorner.bottomLeft.rawValue
            }
            if bottomRight {
                corners |= UIRectCorner.bottomRight.rawValue
            }
            let rectCorner =  UIRectCorner.init(rawValue: corners)
            
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radii, height: radii))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
}
