//
//  UIViewController+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    var topBarsDistance: CGFloat {
        var mTopDistance = self.navigationController?.navigationBar.intrinsicContentSize.height ?? 0
        mTopDistance += UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
        
        return mTopDistance
    }
    
    var bottomBarsDistance: CGFloat {
        return self.tabBarController?.tabBar.intrinsicContentSize.height ?? 0
    }
    
    var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets
        } else {
            return UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: self.bottomLayoutGuide.length, right: 0)
        }
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
        let button = ButtonHandler(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setLeftBarButtonItemCustom(title: String, color: UIColor? = nil, target: Any?, action: Selector) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setLeftBarButtonItemCustom(image: String, maskColor: UIColor? = nil, clickedHandler: ((ButtonHandler) -> ())? = nil) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.onClickedHandler = { [weak self] button in
            clickedHandler?(button)
            if clickedHandler == nil {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setLeftBarButtonItemCustom(title: String, color: UIColor? = nil, clickedHandler: ((ButtonHandler) -> ())? = nil) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.onClickedHandler = { [weak self] button in
            clickedHandler?(button)
            if clickedHandler == nil {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(image: String, maskColor: UIColor? = nil, target: Any?, action: Selector) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(title: String, color: UIColor? = nil, target: Any?, action: Selector) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.addTarget(self, action: action, for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(image: String, maskColor: UIColor? = nil, clickedHandler: ((ButtonHandler) -> ())? = nil) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.onClickedHandler = clickedHandler
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setRightBarButtonItemCustom(title: String, color: UIColor? = nil, clickedHandler: ((ButtonHandler) -> ())? = nil) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.onClickedHandler = clickedHandler
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setBackBarButtonCustom(image: String, maskColor: UIColor? = nil, clickedHandler: ((ButtonHandler) -> ())? = nil) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setImage(UIImage(named: image)?.maskColor(maskColor), for: .normal)
        button.onClickedHandler = { [weak self] btnBlock in
            if clickedHandler == nil {
                self?.navigationController?.popViewController(animated: true)
            } else {
                clickedHandler?(btnBlock)
            }
        }
        
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    @discardableResult
    func setBackBarButtonCustom(title: String, color: UIColor? = nil, clickedHandler: ((ButtonHandler) -> ())? = nil) -> ButtonHandler {
        let button = ButtonHandler(type: .custom)
        button.setTitle(title, for: .normal)
        if color != nil { button.setTitleColor(color!, for: .normal) }
        button.onClickedHandler = { [weak self] btnBlock in
            if clickedHandler == nil {
                self?.navigationController?.popViewController(animated: true)
            } else {
                clickedHandler?(btnBlock)
            }
        }
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }
    
    static var classIdentifier: String {
        return String(describing: self)
    }
    
    // return an instance UIViewController from storyboard with class name identifier
    class func instanceStoryboard(_ storyboard: UIStoryboard) -> Self? {
        return instanceFromStoryboard(storyboard)
    }
    
    private class func instanceFromStoryboard<T: UIViewController>(_ storyboard: UIStoryboard) -> T? {
        return storyboard.instantiateViewController(withIdentifier: T.self.classIdentifier) as? T
    }
}

open class BaseViewController: UIViewController {
    fileprivate var isViewWillAppearAtFirst: Bool = true
    fileprivate var isViewDidAppearAtFirst: Bool = true
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewWillAppearAtFirst = false
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewDidAppearAtFirst(self.isViewDidAppearAtFirst, animated: animated)
        self.isViewDidAppearAtFirst = false
    }
    
    open func viewWillAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
    open func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
}

open class BaseTableViewController: UITableViewController {
    fileprivate var isViewWillAppearAtFirst: Bool = true
    fileprivate var isViewDidAppearAtFirst: Bool = true
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewWillAppearAtFirst = false
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewDidAppearAtFirst(self.isViewDidAppearAtFirst, animated: animated)
        self.isViewDidAppearAtFirst = false
    }
    
    open func viewWillAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
    open func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
}

open class BaseCollectionViewController: UICollectionViewController {
    fileprivate var isViewWillAppearAtFirst: Bool = true
    fileprivate var isViewDidAppearAtFirst: Bool = true
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearAtFirst(self.isViewWillAppearAtFirst, animated: animated)
        self.isViewWillAppearAtFirst = false
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewDidAppearAtFirst(self.isViewDidAppearAtFirst, animated: animated)
        self.isViewDidAppearAtFirst = false
    }
    
    open func viewWillAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
    open func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) { }
}
