//
//  UIViewController+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm. All rights reserved.
//

import Foundation
import UIKit

class BarButtonCustom: UIButton {
    var clickedHandler: (() -> Void)? {
        didSet {
            self.removeTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
            self.addTarget(self, action: #selector(didClickedAction), for: .touchUpInside)
        }
    }
    
    @objc private func didClickedAction() {
        self.clickedHandler?()
    }
}

extension UIViewController {
    var topDistance: CGFloat {
        var mTopDistance = self.navigationController?.navigationBar.intrinsicContentSize.height ?? 0
        mTopDistance += UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
        
        return mTopDistance
    }
    
    var topMostViewController: UIViewController {
        if let viewController = self as? UINavigationController {
            return viewController.topViewController?.topMostViewController ?? viewController
        } else if let viewController = self as? UITabBarController {
            return viewController.selectedViewController?.topMostViewController ?? viewController
        } else if let viewController = self.presentedViewController {
            return viewController.topMostViewController
        }
        return self
    }
    
    var visibleMostViewController: UIViewController {
        if let viewController = self as? UINavigationController {
            return viewController.visibleViewController?.visibleMostViewController ?? self
        } else if let viewController = self as? UITabBarController {
            return viewController.selectedViewController?.visibleMostViewController ?? self
        } else if let viewController = self.presentedViewController {
            return viewController.visibleMostViewController
        }
        return self
    }
    
    @discardableResult
    func setLeftBarButtonItemCustom(image: String, maskColor: UIColor? = nil, target: Any?, action: Selector) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setLeftBarButtonItemCustom(title: String, color: UIColor? = nil, target: Any?, action: Selector) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setLeftBarButtonItemCustom(image: String, maskColor: UIColor? = nil, clickedHandler: (() -> ())? = nil) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.clickedHandler = { [weak self] in
            clickedHandler?()
            if clickedHandler == nil {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setLeftBarButtonItemCustom(title: String, color: UIColor? = nil, clickedHandler: (() -> ())? = nil) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.clickedHandler = { [weak self] in
            clickedHandler?()
            if clickedHandler == nil {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(image: String, maskColor: UIColor? = nil, target: Any?, action: Selector) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(title: String, color: UIColor? = nil, target: Any?, action: Selector) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.addTarget(self, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(image: String, maskColor: UIColor? = nil, clickedHandler: (() -> ())? = nil) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.clickedHandler = clickedHandler
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(title: String, color: UIColor? = nil, clickedHandler: (() -> ())? = nil) -> UIButton {
        let button = BarButtonCustom(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.clickedHandler = clickedHandler
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
}

class BaseViewController: UIViewController {
    fileprivate var isViewWillAppearAtFirst: Bool = true
    fileprivate var isViewDidAppearAtFirst: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewWillAppearAtFirst = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewDidAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewDidAppearAtFirst = false
    }
    
    func viewWillAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
    func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
}

class BaseTableViewController: UITableViewController {
    fileprivate var isViewWillAppearAtFirst: Bool = true
    fileprivate var isViewDidAppearAtFirst: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewWillAppearAtFirst = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewDidAppearAtFirst(self.isViewDidAppearAtFirst, animated: animated)
        self.isViewDidAppearAtFirst = false
    }
    
    func viewWillAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
    func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
}

class BaseCollectionViewController: UICollectionViewController {
    fileprivate var isViewWillAppearAtFirst: Bool = true
    fileprivate var isViewDidAppearAtFirst: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewWillAppearAtFirst = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewDidAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewDidAppearAtFirst = false
    }
    
    func viewWillAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
    func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
}
