//
//  UIApplication+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm. All rights reserved.
//

import Foundation
import UIKit

public extension UIApplication {
    static var appVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0.0"
    }
    
    static var appBuild: String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? "1"
    }
    
    static var appVersionBuild: String {
        return "v\(self.appVersion)(\(self.appBuild))"
    }
    
    class var topMostViewController: UIViewController? {
        return self.shared.delegate?.window??.rootViewController?.topMostViewController
    }
    
    class var visibleMostViewController: UIViewController? {
        return self.shared.delegate?.window??.rootViewController?.visibleMostViewController
    }
    
    class func openUrlString(_ urlString: String?) {
        if let stringUrl = urlString, let url = URL(string: stringUrl) {
            if #available(iOS 10.0, *) {
                self.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.shared.openURL(url)
            }
        }
    }
    
    static var statusBarView: UIView? {
        return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
    }
    
    static func switchRootViewController(to rootViewController: UIViewController, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first else {
            completion?(false)
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                completion?(true)
            })
        } else {
            window.rootViewController = rootViewController
            completion?(true)
        }
    }
}

public extension UIResponder {
    private weak static var currentFirstResponder__: UIResponder?
    
    class func currentFirstResponder() -> UIResponder? {
        UIResponder.currentFirstResponder__ = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder.currentFirstResponder__
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder.currentFirstResponder__ = self
    }
    
    static func sharedAppDelegate<T: UIResponder>() -> T? {
        return UIApplication.shared.delegate as? T
    }
}

public extension DispatchTime {
    static func uptimeSeconds(_ seconds: Double) -> DispatchTime {
        return DispatchTime.now() + seconds
    }
    
    init(uptimeSeconds: Double) {
        self.init(uptimeNanoseconds: UInt64(uptimeSeconds * pow(10, 9)))
    }
}

public extension DispatchQueue {
    class func mainAsync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.async(execute: work)
    }
    
    class func mainSync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.sync(execute: work)
    }
    
    class func mainAsyncAfter(seconds: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            DispatchQueue.mainAsync(execute: work)
        }
    }
    
    class func mainSyncAfter(seconds: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            DispatchQueue.mainSync(execute: work)
        }
    }
    
    class func globalAsync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.global().async(execute: work)
    }
    
    class func globalSync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.global().sync(execute: work)
    }
}
