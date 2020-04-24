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

    static func switchRootViewController(to newRootViewController: UIViewController, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let window = appKeyWindow else {
            completion?(false)
            return
        }
        
        guard animated else {
            window.rootViewController = newRootViewController
            window.makeKeyAndVisible()
            completion?(true)
            return
        }

        window.rootViewController = newRootViewController
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: { _ in
                              completion?(true)
                          })
    }
}

extension UIApplication {
    static var delegateKeyWindow: UIWindow? { return self.shared.delegate?.window ?? nil }
    static func canOpen(url string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return shared.canOpenURL(url)
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

    private static func sharedAppDelegate<T: UIResponder>() -> T? {
        return UIApplication.shared.delegate as? T
    }
    static var shared: Self { return self.sharedAppDelegate()! }
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
    func hexadecimal(uppercase: Bool = true) -> String {
        var result = ""
        let format = uppercase ? "%02X" : "%02x"
        withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            pointer.forEach { result += String(format: format, $0) }
        }
        return result
    }
    
    func deviceTokenString() -> String {
        let tokenParts = self.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        return tokenParts.joined()
    }
    
    var stringUTF8: String? { return String(data: self, encoding: .utf8) }
}

@available(iOS 10.0, *)
public extension UNUserNotificationCenter {
    class func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Swift.Void) {
        current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completionHandler(settings)
            }
        }
    }
    
    class func requestAuthorization(options: UNAuthorizationOptions = [], completionHandler: @escaping (Bool, Error?) -> Void) {
        current().requestAuthorization(options: options, completionHandler: completionHandler)
    }
}

public struct LHNotificationOptions : OptionSet {
    public var rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static var badge: LHNotificationOptions {
        if #available(iOS 10.0, *) {
            return LHNotificationOptions(rawValue: UNAuthorizationOptions.badge.rawValue)
        } else {
            return LHNotificationOptions(rawValue: UIUserNotificationType.badge.rawValue)
        }
    }

    public static var sound: LHNotificationOptions {
        if #available(iOS 10.0, *) {
            return LHNotificationOptions(rawValue: UNAuthorizationOptions.sound.rawValue)
        } else {
            return LHNotificationOptions(rawValue: UIUserNotificationType.sound.rawValue)
        }
    }

    public static var alert: LHNotificationOptions {
        if #available(iOS 10.0, *) {
            return LHNotificationOptions(rawValue: UNAuthorizationOptions.alert.rawValue)
        } else {
            return LHNotificationOptions(rawValue: UIUserNotificationType.alert.rawValue)
        }
    }
    
    @available(iOS 10.0, *)
    public static var carPlay: LHNotificationOptions {
        return LHNotificationOptions(rawValue: UNAuthorizationOptions.carPlay.rawValue)
    }
    
    @available(iOS 12.0, *)
    public static var criticalAlert: LHNotificationOptions {
        return LHNotificationOptions(rawValue: UNAuthorizationOptions.criticalAlert.rawValue)
    }
    
    @available(iOS 12.0, *)
    public static var providesAppNotificationSettings: LHNotificationOptions {
        return LHNotificationOptions(rawValue: UNAuthorizationOptions.providesAppNotificationSettings.rawValue)
    }
    
    @available(iOS 12.0, *)
    public static var provisional: LHNotificationOptions {
        return LHNotificationOptions(rawValue: UNAuthorizationOptions.provisional.rawValue)
    }
    
    @available(iOS 13.0, *)
    public static var announcement: LHNotificationOptions {
        return LHNotificationOptions(rawValue: UNAuthorizationOptions.announcement.rawValue)
    }
    
    var userNotificationType: UIUserNotificationType { return UIUserNotificationType(rawValue: rawValue) }
    
    @available(iOS 10.0, *)
    var authorizationOptions: UNAuthorizationOptions { return UNAuthorizationOptions(rawValue: rawValue) }
}
