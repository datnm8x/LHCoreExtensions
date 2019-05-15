//
//  UINavigationController+Ex.swift
//  LHCoreExtensions iOS
//
//  Created by Dat Ng on 5/15/19.
//  Copyright © 2019 Lao Hac. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationController {
    var rootViewController: UIViewController? { return self.viewControllers.first }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    @discardableResult
    func popViewController(animated: Bool, completion: @escaping () -> Void) -> UIViewController? {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let results = self.popViewController(animated: animated)
        CATransaction.commit()
        return results
    }
    
    @discardableResult
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let results = self.popToViewController(viewController, animated: animated)
        CATransaction.commit()
        return results
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let results = self.popToRootViewController(animated: animated)
        CATransaction.commit()
        return results
    }
}

