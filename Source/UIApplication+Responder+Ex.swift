//
//  UIApplication+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
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

    class var rootViewController: UIViewController? { return self.shared.delegate?.window??.rootViewController }

    class var topMostViewController: UIViewController? {
        return self.rootViewController?.topMostViewController
    }

    class var visibleMostViewController: UIViewController? {
        return self.rootViewController?.visibleMostViewController
    }

    class func canOpenUrlString(_ urlString: String?) -> Bool {
        guard let stringUrl = urlString, let url = URL(string: stringUrl) else { return false }
        return self.shared.canOpenURL(url)
    }

    class func openUrlString(_ urlString: String?) {
        if let stringUrl = urlString, let url = URL(string: stringUrl) {
            if #available(iOS 10.0, *) {
                self.shared.open(url, options: [:], completionHandler: nil)
            } else {
                _ = self.shared.openURL(url)
            }
        }
    }

    static var statusBarView: UIView? {
        return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
    }

    static var appKeyWindow: UIWindow? {
        return (self.delegateKeyWindow ?? UIApplication.shared.keyWindow) ?? UIApplication.shared.windows.first
    }

    static func switchRootViewController(to rootViewController: UIViewController, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let window = appKeyWindow else {
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
                window.makeKeyAndVisible()
                completion?(true)
            })
        } else {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            completion?(true)
        }
    }
}

extension UIApplication {
    static var delegateKeyWindow: UIWindow? { return self.shared.delegate?.window ?? nil }
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
    static var background: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)

    class func mainAsync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.async {
            work()
        }
    }

    class func mainAsyncAfter(seconds: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            DispatchQueue.main.async {
                work()
            }
        }
    }

    class func mainSyncAfter(seconds: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            DispatchQueue.main.sync {
                work()
            }
        }
    }

    class func backgroundAsync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.background.async {
            work()
        }
    }

    class func backgroundAsyncAfter(seconds: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.background.asyncAfter(deadline: .now() + seconds) {
            work()
        }
    }

    class func backgroundSync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.background.sync {
            work()
        }
    }

    class func serialAsync(_ label: String = "DispatchSerial", execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue(label: label).async {
            work()
        }
    }

    class func serialAsyncAfter(_ label: String = "DispatchSerial", seconds: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue(label: label).asyncAfter(deadline: .now() + seconds) {
            work()
        }
    }
}

public extension Data {
    func deviceTokenString() -> String {
        let tokenParts = self.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        return tokenParts.joined()
    }
}
