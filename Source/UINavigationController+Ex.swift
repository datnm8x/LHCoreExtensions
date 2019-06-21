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
    
    // This function will be push viewController, and then remove all viewControllers in stack and only keep rootViewController of stack
    func pushViewControllerAndRemoveBefores(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        self.pushViewController(viewController, animated: animated) { [weak self] in
            guard let firstVC = self?.viewControllers.first, let lastVC = self?.viewControllers.last, firstVC != lastVC else {
                completion?()
                return
            }
            self?.viewControllers = [firstVC, lastVC]
            completion?()
        }
    }
    
    // if stacks include viewController, remove all viewControllers from viewController position, and push viewController again, other, push in viewController
    func pushToViewControllerBefore(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        var stackVCs = self.viewControllers
        let indexVc = stackVCs.remove(object: viewController)
        self.viewControllers = stackVCs
        var stackFinal = [UIViewController]()
        let indexVcFinal = indexVc ?? stackVCs.count
        for idx: Int in 0..<indexVcFinal {
            stackFinal.append(stackVCs[idx])
        }
        stackFinal.append(viewController)
        self.pushViewController(viewController, animated: animated) { [weak self] in
            self?.viewControllers = stackFinal
            completion?()
        }
    }
}

