//
//  UIButton+Ex.swift
//  CoreExtensions
//
//  Created by Dat Ng on 4/18/19.
//  Copyright © 2019 Dat Ng. All rights reserved.
//

import Foundation
import UIKit

open class ButtonHandler: UIButton {
    private var isSetupCommon: Bool = false
    
    @objc private func didClickedAction() {
        self.onClickedHandler?(self)
    }
    
    open var onClickedHandler: ((ButtonHandler) -> Void)? {
        didSet {
            self.removeTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
            self.addTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        guard !isSetupCommon else { return }
        isSetupCommon = true
        
        backgroundColors[self.state.rawValue] = self.backgroundColorFor(state: self.state)
    }
    
    private var backgroundColors: [UIControl.State.RawValue: UIColor?] = [UIControl.State.RawValue: UIColor?]()
    
    open func setBackgroundColor(_ bkgColor: UIColor?, for state: UIControl.State) {
        backgroundColors[state.rawValue] = bkgColor
        if state == .normal {
            if self.backgroundColorFor(state: UIControl.State.selected) == nil {
                backgroundColors[UIControl.State.selected.rawValue] = bkgColor
            }
            
            if self.backgroundColorFor(state: UIControl.State.highlighted) == nil {
                backgroundColors[UIControl.State.highlighted.rawValue] = bkgColor
            }
        }
        
        if self.state == state {
            self.backgroundColor = bkgColor
        }
    }
    
    open func backgroundColorFor(state: UIControl.State) -> UIColor? {
        return backgroundColors[state.rawValue] as? UIColor
    }
    
    override open var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.backgroundColorFor(state: self.state)
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            self.backgroundColor = self.backgroundColorFor(state: self.state)
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            self.backgroundColor = self.backgroundColorFor(state: self.state)
        }
    }
}