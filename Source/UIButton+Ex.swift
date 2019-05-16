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
    @objc private func didClickedAction() {
        self.onClickedHandler?(self)
    }
    
    open var onClickedHandler: ((ButtonHandler) -> Void)? {
        didSet {
            self.removeTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
            self.addTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
        }
    }
}
