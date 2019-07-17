//
//  UIButton+Ex.swift
//  CoreExtensions
//
//  Created by Dat Ng on 4/18/19.
//  Copyright © 2019 Dat Ng. All rights reserved.
//

import Foundation
import UIKit

open class LHButtonHandler: UIButton {
    @objc private func didClickedAction() {
        self.onClickedHandler?(self)
    }
    
    open var onClickedHandler: ((LHButtonHandler) -> Void)? {
        didSet {
            self.removeTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
            self.addTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
        }
    }
}

@IBDesignable open class LHGradientButton: LHButtonHandler {
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
}
