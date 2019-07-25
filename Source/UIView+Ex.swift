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

public extension CAGradientLayerType {
    static let linear = CAGradientLayerType.axial
}

/// The direction of the gradient.
public enum LHGradientDirection {
    /// The gradient is vertical.
    case vertical
    
    /// The gradient is horizontal
    case horizontal
    
    case diagonalUp
    
    case diagonalDown
    
    /// The gradient with position:
    /// [0,0] is the bottom-left corner of the layer, [1,1] is the top-right corner.
    case position((startPoint: CGPoint, endPoint: CGPoint))
}

public func == (lhs: LHGradientDirection, rhs: LHGradientDirection) -> Bool {
    switch (lhs, rhs) {
    case ( .vertical, .vertical): return true
    case ( .horizontal, .horizontal): return true
    case ( .diagonalUp, .diagonalUp): return true
    case ( .diagonalDown, .diagonalDown): return true
    case (.position(let lhsPoint), .position(let rhsPoint)): return lhsPoint == rhsPoint
    default: return false
    }
}

@IBDesignable open class LHGradientView: UIView {
    // MARK: - Class methods
    open override class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: - Public properties
    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    open var direction: LHGradientDirection = .vertical { didSet { updateGradient() } }
    open var colors: [UIColor]? { didSet { updateGradient() } }
    open var locations: [Float]? { didSet { updateGradient() } }
    open var gradientType: CAGradientLayerType = .linear { didSet { updateGradient() } }
    
    open func updateGradient() {
        gradientLayer.type = gradientType
        gradientLayer.locations = locations?.map({ (loc) -> NSNumber in
            return NSNumber(value: loc)
        })
        gradientLayer.colors = colors?.map({ (gColor) -> CGColor in
            return gColor.cgColor
        })
        
        switch direction {
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .diagonalUp:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        case .diagonalDown:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            
        case .position(let position):
            gradientLayer.startPoint = position.startPoint
            gradientLayer.endPoint = position.endPoint
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.updateGradient()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.updateGradient()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.updateGradient()
    }
}

public extension UIRectCorner {
    var isCornerAll: Bool {
        if self.contains(.allCorners) { return true }
        if !self.contains(.topLeft) { return false }
        if !self.contains(.topRight) { return false }
        if !self.contains(.bottomLeft) { return false }
        if !self.contains(.bottomRight) { return false }
        return true
    }
}

extension UIView {
    @IBInspectable
    open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            updateBorderCorners()
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
            updateBorderCorners()
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get { return layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!) }
        set {
            layer.borderColor = newValue?.cgColor
            updateBorderCorners()
        }
    }
    
    @objc fileprivate func updateBorderCorners() {
        if cornerRadius > 0 || borderWidth > 0 { clipsToBounds = true }
        setNeedsDisplay()
    }
}

@IBDesignable
open class LHRoundCornerView: UIView {
    fileprivate var privateCornerRadius: CGFloat = 0.0 { didSet { updateBorderCorners() } }
    fileprivate var privateBorderWidth: CGFloat = 0.0 { didSet { updateBorderCorners() } }
    fileprivate var privateBorderColor: UIColor? = nil { didSet { updateBorderCorners() } }
    //    open override class var layerClass : AnyClass { return CAShapeLayer.self }
    //    var shapeLayer: CAShapeLayer { return self.layer as! CAShapeLayer }
    open var cornersAt: UIRectCorner = .allCorners { didSet { updateBorderCorners() } }
    
    override open var cornerRadius: CGFloat {
        get { return self.privateCornerRadius }
        set { self.privateCornerRadius = newValue }
    }
    
    override open var borderWidth: CGFloat {
        get { return self.privateBorderWidth }
        set { self.privateBorderWidth = newValue }
    }
    
    override open var borderColor: UIColor? {
        get { return self.privateBorderColor }
        set { self.privateBorderColor = newValue }
    }
    
    @objc override open func setCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        self.cornersAt = .allCorners
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }
    
    @objc override fileprivate func updateBorderCorners() {
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            var caCornerMask: CACornerMask = []
            if cornersAt.contains(.topLeft) { caCornerMask.formUnion(.layerMinXMinYCorner) }
            if cornersAt.contains(.bottomLeft) { caCornerMask.formUnion(.layerMinXMaxYCorner) }
            if cornersAt.contains(.topRight) { caCornerMask.formUnion(.layerMaxXMinYCorner) }
            if cornersAt.contains(.bottomRight) { caCornerMask.formUnion(.layerMaxXMaxYCorner) }
            if cornersAt == .allCorners { caCornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner] }
            
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            layer.maskedCorners = caCornerMask
        } else {
            setNeedsDisplay()
        }
    }
    
    lazy var maskLayer: CAShapeLayer? = {
        if #available(iOS 11.0, *) {
            return nil
        } else {
            return CAShapeLayer()
        }
    }()
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if #available(iOS 11.0, *) {
            
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornersAt, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
            path.lineWidth = self.borderWidth * 2.0
            self.borderColor?.setStroke()
            path.stroke()
            
            maskLayer?.frame = self.bounds
            maskLayer?.path = path.cgPath
            maskLayer?.masksToBounds = true
            layer.masksToBounds = true
            layer.mask = maskLayer
            maskLayer?.setNeedsDisplay()
            maskLayer?.setNeedsLayout()
        }
    }
    
    override open var clipsToBounds: Bool {
        get { return true }
        set { super.clipsToBounds = true }
    }
    
    @IBInspectable
    var cornerTopLeft: Bool {
        get { return cornersAt.contains(.topLeft) || cornersAt == .allCorners }
        set {
            mergeCorner(.topLeft, isEnable: newValue)
        }
    }
    @IBInspectable
    var cornerTopRight: Bool {
        get { return cornersAt.contains(.topRight) || cornersAt == .allCorners }
        set { mergeCorner(.topRight, isEnable: newValue) }
    }
    @IBInspectable
    var cornerBottomLeft: Bool {
        get { return cornersAt.contains(.bottomLeft) || cornersAt == .allCorners }
        set { mergeCorner(.bottomLeft, isEnable: newValue) }
    }
    @IBInspectable
    var cornerBottomRight: Bool {
        get { return cornersAt.contains(.bottomRight) || cornersAt == .allCorners }
        set { mergeCorner(.bottomRight, isEnable: newValue) }
    }
    
    func mergeCorner(_ corner: UIRectCorner, isEnable: Bool) {
        if isEnable {
            if cornersAt.contains(corner) || cornersAt == .allCorners {
                return
            }
            cornersAt.formUnion(corner)
        } else {
            cornersAt.remove(corner)
        }
        updateBorderCorners()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateBorderCorners()
    }
    
    open override var frame: CGRect {
        didSet {
            updateBorderCorners()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        updateBorderCorners()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        updateBorderCorners()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        updateBorderCorners()
    }
}

@IBDesignable
open class LHRoundShadowView: UIView {
    let containerView = LHRoundCornerView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        commonLayoutViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonLayoutViews()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        commonLayoutViews()
        setNeedsDisplay()
    }
    
    // MARK: - Init View
    func commonLayoutViews() {
        // set the shadow of the view's layer
        super.backgroundColor = UIColor.clear
        layer.backgroundColor = UIColor.clear.cgColor
        clipsToBounds = false
        
        // set the cornerRadius of the containerView's layer
        containerView.backgroundColor = UIColor.white
        containerView.clipsToBounds = true
        insertSubview(containerView, at: 0)
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        let constraints = [
            NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ]
        super.addConstraints(constraints)
        constraints.forEach { (constraint) in
            constraint.isActive = true
        }
    }
    
    // MARK: - Shadow effects
    override open var clipsToBounds: Bool {
        get { return false }
        set { super.clipsToBounds = false }
    }
    
    override open var backgroundColor: UIColor? {
        get { return containerView.backgroundColor }
        set { containerView.backgroundColor = newValue }
    }
    
    @IBInspectable
    open var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var shadowOpacity: Float = 1.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var shadowOffset: CGPoint = CGPoint(x: 0, y: -3) {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var shadowBlur: CGFloat = 6.0 {
        didSet {
            layer.shadowRadius = shadowBlur / 2
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var shadowSpread: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if shadowSpread == 0.0 { layer.shadowPath = nil }
        else {
            let dx = -shadowSpread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    // MARK: - override proccess for subviews
    override open func addSubview(_ view: UIView) {
        guard view != containerView else {
            super.addSubview(view)
            return
        }
        containerView.addSubview(view)
    }
    
    override open func insertSubview(_ view: UIView, at index: Int) {
        guard view != containerView else {
            super.insertSubview(view, at: index)
            return
        }
        containerView.insertSubview(view, at: index)
    }
    
    open override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        guard view != containerView else {
            super.insertSubview(view, aboveSubview: siblingSubview)
            return
        }
        containerView.insertSubview(view, aboveSubview: siblingSubview)
    }
    
    open override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        guard view != containerView else {
            super.insertSubview(view, belowSubview: siblingSubview)
            return
        }
        containerView.insertSubview(view, belowSubview: siblingSubview)
    }
    
    override open func addConstraint(_ constraint: NSLayoutConstraint) {
        processAddConstraint(constraint)
    }
    
    fileprivate func processAddConstraint(_ constraint: NSLayoutConstraint) {
        guard let firstItem = constraint.firstItem as? UIView, let seconItem = constraint.secondItem as? UIView else {
            super.addConstraint(constraint)
            return
        }
        
        if firstItem != self && seconItem != self {
            containerView.addConstraint(constraint)
        } else if firstItem == self && seconItem != self {
            let copyConstraint = NSLayoutConstraint(item: containerView, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant)
            containerView.addConstraint(copyConstraint)
        } else if seconItem == self && firstItem != self {
            let copyConstraint = NSLayoutConstraint(item: firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: containerView, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant)
            containerView.addConstraint(copyConstraint)
        } else {
            super.addConstraint(constraint)
        }
    }
    
    open override func addConstraints(_ constraints: [NSLayoutConstraint]) {
        constraints.forEach { [weak self] (constraint) in
            self?.processAddConstraint(constraint)
        }
    }
    
    // MARK: - Corner effects
    open var cornersAt: UIRectCorner {
        get { return containerView.cornersAt }
        set { containerView.cornersAt = newValue }
    }
    
    override open var cornerRadius: CGFloat {
        get { return containerView.cornerRadius }
        set { containerView.cornerRadius = newValue }
    }
    
    override open var borderWidth: CGFloat {
        get { return containerView.borderWidth }
        set { containerView.borderWidth = newValue }
    }
    
    override open var borderColor: UIColor? {
        get { return containerView.borderColor }
        set { containerView.borderColor = newValue }
    }
    
    @IBInspectable
    var cornerTopLeft: Bool {
        get { return containerView.cornerTopLeft }
        set { containerView.cornerTopLeft = newValue }
    }
    @IBInspectable
    var cornerTopRight: Bool {
        get { return containerView.cornerTopRight }
        set { containerView.cornerTopRight = newValue }
    }
    @IBInspectable
    var cornerBottomLeft: Bool {
        get { return containerView.cornerBottomLeft }
        set { containerView.cornerBottomLeft = newValue }
    }
    @IBInspectable
    var cornerBottomRight: Bool {
        get { return containerView.cornerBottomRight }
        set { containerView.cornerBottomRight = newValue }
    }
    
    @objc override open func setCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        containerView.setCornerRadius(cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    public func applySketchShadow(color: UIColor = .black, opacity: Float = 1.0, x: CGFloat = 0, y: CGFloat = -3, blur: CGFloat = 6, spread: CGFloat = 0) {
        self.shadowColor = color
        self.shadowOpacity = opacity
        self.shadowOffset = CGPoint(x: x, y: y)
        self.shadowBlur = blur
        self.shadowSpread = spread
    }
}

/*
extension CALayer {
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
        masksToBounds = false
    }
}
*/
