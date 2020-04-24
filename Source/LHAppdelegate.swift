//
//  LHAppdelegate.swift
//  LHCoreExtensions iOS
//
//  Created by Nguyen Mau Dat on 4/24/20.
//  Copyright © 2020 Lao Hac. All rights reserved.
//

import Foundation
import UIKit

public typealias LHRegisterRemoteNotificationCompletion = (_ deviceToken: Data?, _ error: Error?) -> Void

@UIApplicationMain
open class LHAppDelegate: UIResponder, UIApplicationDelegate {
    private var registerRemoteNotificationCompletion: LHRegisterRemoteNotificationCompletion?
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        registerRemoteNotificationCompletion?(deviceToken, nil)
        registerRemoteNotificationCompletion = nil
    }
    
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        registerRemoteNotificationCompletion?(nil, error)
        registerRemoteNotificationCompletion = nil
    }
    
    open func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}

public extension LHAppDelegate {
    func registerRemoteNotification(options: LHNotificationOptions = [.alert, .sound, .badge],
                                    completionHandler: LHRegisterRemoteNotificationCompletion?) {
        let domain = self.description
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.requestAuthorization(options: options.authorizationOptions) { [weak self] (granted, error) in
                guard granted else {
                    completionHandler?(nil, error ?? NSError(domain: domain, code: 401, userInfo: [:]))
                    return
                }
                
                UNUserNotificationCenter.getNotificationSettings { (settings) in
                    guard settings.authorizationStatus == .authorized else {
                        completionHandler?(nil, error ?? NSError(domain: domain, code: 401, userInfo: ["settings": settings]))
                        return
                    }
                    
                    self?.registerRemoteNotificationCompletion = completionHandler
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            self.registerRemoteNotificationCompletion = completionHandler
            let settings = UIUserNotificationSettings(types: options.userNotificationType, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}


/*
public protocol UIApplicationDelegate : NSObjectProtocol {

    @available(iOS 2.0, *)
    optional func applicationDidFinishLaunching(_ application: UIApplication)

    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool

    @available(iOS 3.0, *)
    optional func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool

    @available(iOS 2.0, *)
    optional func applicationDidBecomeActive(_ application: UIApplication)

    @available(iOS 2.0, *)
    optional func applicationWillResignActive(_ application: UIApplication)

    @available(iOS, introduced: 2.0, deprecated: 9.0)
    optional func application(_ application: UIApplication, handleOpen url: URL) -> Bool

    @available(iOS, introduced: 4.2, deprecated: 9.0)
    optional func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool

    @available(iOS 9.0, *)
    optional func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool

    @available(iOS 2.0, *)
    optional func applicationDidReceiveMemoryWarning(_ application: UIApplication)

    @available(iOS 2.0, *)
    optional func applicationWillTerminate(_ application: UIApplication)

    @available(iOS 2.0, *)
    optional func applicationSignificantTimeChange(_ application: UIApplication)

    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    optional func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval)

    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    optional func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation)

    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    optional func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect)

    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    optional func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect)

    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    optional func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)

    @available(iOS 3.0, *)
    optional func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)

    @available(iOS 3.0, *)
    optional func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)

    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])

    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    optional func application(_ application: UIApplication, didReceive notification: UILocalNotification)

    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    optional func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void)

    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    optional func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)

    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    optional func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)

    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    optional func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)

    /** This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    @available(iOS 7.0, *)
    optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)

    /// Applications with the "fetch" background mode may be given opportunities to fetch updated content in the background or when it is convenient for the system. This method will be called in these situations. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
    @available(iOS, introduced: 7.0, deprecated: 13.0, message: "Use a BGAppRefreshTask in the BackgroundTasks framework instead")
    optional func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)

    @available(iOS 9.0, *)
    optional func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void)

    @available(iOS 7.0, *)
    optional func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void)

    @available(iOS 8.2, *)
    optional func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void)

    @available(iOS 9.0, *)
    optional func applicationShouldRequestHealthAuthorization(_ application: UIApplication)

    @available(iOS 11.0, *)
    optional func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void)

    @available(iOS 4.0, *)
    optional func applicationDidEnterBackground(_ application: UIApplication)

    @available(iOS 4.0, *)
    optional func applicationWillEnterForeground(_ application: UIApplication)

    @available(iOS 4.0, *)
    optional func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication)

    @available(iOS 4.0, *)
    optional func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication)

    @available(iOS 5.0, *)
    optional var window: UIWindow? { get set }

    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask

    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool

    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController?

    @available(iOS 13.2, *)
    optional func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool

    @available(iOS 13.2, *)
    optional func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool

    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder)

    @available(iOS 6.0, *)
    optional func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder)

    @available(iOS, introduced: 6.0, deprecated: 13.2, message: "Use application:shouldSaveSecureApplicationState: instead")
    optional func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool

    @available(iOS, introduced: 6.0, deprecated: 13.2, message: "Use application:shouldRestoreSecureApplicationState: instead")
    optional func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool

    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool

    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool

    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error)

    @available(iOS 8.0, *)
    optional func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity)

    @available(iOS 10.0, *)
    optional func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata)

    @available(iOS 13.0, *)
    optional func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration

    @available(iOS 13.0, *)
    optional func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
}
*/
