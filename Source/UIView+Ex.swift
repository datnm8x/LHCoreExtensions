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
    @IBInspectable var cornerRadius: Float {
        get { return Float(layer.cornerRadius) }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = CGFloat(newValue)
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: Float {
        get { return Float(layer.borderWidth) }
        set {
            layer.borderWidth = CGFloat(newValue)
            setNeedsLayout()
            setNeedsDisplay()
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
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    @objc func setCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
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
    
    func applySketchShadow(
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
    }
}

public extension UIRectCorner {
    
    var isAll: Bool {
        if self.contains(.allCorners) { return true }
        if !self.contains(.topLeft) { return false }
        if !self.contains(.topRight) { return false }
        if !self.contains(.bottomLeft) { return false }
        if !self.contains(.bottomRight) { return false }
        return true
    }
}

open class LHCornerView: UIView {
    private var pCornerRadius: CGFloat = 0.0
    private var pBorderWidth: CGFloat = 0.0
    private var pBorderColor: UIColor?
    open var cornersAt: UIRectCorner = .allCorners {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override open var cornerRadius: Float {
        get { return Float(pCornerRadius) }
        set {
            pCornerRadius = CGFloat(newValue)
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override open var borderWidth: Float {
        get { return Float(pBorderWidth) }
        set {
            pBorderWidth = CGFloat(newValue)
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override open var borderColor: UIColor? {
        get {
            return pBorderColor
        }
        set {
            pBorderColor = newValue
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    @objc override open func setCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        pCornerRadius = cornerRadius
        pBorderWidth = borderWidth
        pBorderColor = borderColor
        setNeedsDisplay()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornersAt, cornerRadii: CGSize(width: pCornerRadius, height: pCornerRadius))
        path.lineWidth = pBorderWidth
        pBorderColor?.setStroke()
        path.stroke()
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        maskLayer.strokeColor = pBorderColor?.cgColor
        
        self.layer.mask = maskLayer
    }
}

public extension CAGradientLayerType {
    static let linear = CAGradientLayerType.axial
}

@IBDesignable open class LHGradientView: UIView {
    /// The direction of the gradient.
    public enum Direction: String {
        /// The gradient is vertical.
        case vertical = "vertical"
        
        /// The gradient is horizontal
        case horizontal = "horizontal"
    }
    
    // MARK: - Class methods
    open override class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: - Public properties
    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    open var direction: Direction = .vertical { didSet { updateGradient() } }
    open var colors: [UIColor]? { didSet { updateGradient() } }
    open var locations: [Float]? { didSet { updateGradient() } }
//    open var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) { didSet { updateGradient() } }
//    open var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) { didSet { updateGradient() } }
    open var gradientType: CAGradientLayerType = .linear { didSet { updateGradient() } }
    
    open func updateGradient() {
        gradientLayer.type = gradientType
        gradientLayer.locations = locations?.map({ (loc) -> NSNumber in
            return NSNumber(value: loc)
        })
        gradientLayer.colors = colors?.map({ (gColor) -> CGColor in
            return gColor.cgColor
        })
        if direction == .vertical {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        setNeedsDisplay()
        gradientLayer.setNeedsDisplay()
        gradientLayer.setNeedsLayout()
    }
    
    @IBInspectable
    var verticalDirection: Bool {
        get { return direction == .vertical }
        set { direction = newValue ? .vertical : .horizontal }
    }
    
    @IBInspectable
    var startColor: UIColor? {
        didSet {
            var mColors = colors ?? [UIColor]()
            if mColors.count > 0 { mColors.remove(at: 0) }
            
            if let sColor = startColor {
                mColors.insert(sColor, at: 0)
            }
            
            self.colors = mColors
        }
    }
    
    @IBInspectable
    var endColor: UIColor? {
        get { return colors?.first }
        set {
            var mColors = colors ?? [UIColor]()
            if mColors.count > 1 { mColors.remove(at: 1) }
            
            if let eColor = newValue {
                mColors.append(eColor)
            }
            self.colors = mColors
        }
    }
}
