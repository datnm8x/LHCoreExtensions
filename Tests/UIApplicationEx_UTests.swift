//
//  UIApplicationEx_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 4/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class UIApplicationEx_UTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        expect(UIApplication.appVersionBuild).to(equal("v1.0(1)"))
        _ = UIApplication.topMostViewController
        _ = UIApplication.visibleMostViewController
        UIApplication.openUrlString("https://www.google.com.vn/")
        _ = UIApplication.statusBarView
        _ = AppDelegate.sharedAppDelegate()
        _ = AppDelegate.currentFirstResponder()
        let mainVCTestAnimated = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        UIApplication.switchRootViewController(to: mainVCTestAnimated, animated: true) { (finish) in
            DebugLog("switchRootViewController: \(finish)")
        }
        
        let mainVCTest = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        UIApplication.switchRootViewController(to: mainVCTest, animated: false) { (finish) in
            DebugLog("switchRootViewController: \(finish)")
        }
        
        let delay = 0.0
        
        DispatchQueue.mainAsync {
            DebugLog("DispatchQueue.mainAsync")
        }
        
        DispatchQueue.mainAsyncAfter(seconds: delay) {
            DebugLog("DispatchQueue.mainAsyncAfter")
        }
        
        DispatchQueue.mainSyncAfter(seconds: delay) {
            let number = 1 + 1
            DebugLog("DispatchQueue.mainSyncAfter: \(number)")
        }
        
        DispatchQueue.backgroundSync {
            DispatchQueue.mainSyncAfter(seconds: delay) {
                let number = 1 + 1
                DebugLog("DispatchQueue.backgroundSync: \(number)")
            }
        }
        
        DispatchQueue.backgroundAsync {
            DebugLog("DispatchQueue.backgroundAsync")
        }
        
        DispatchQueue.backgroundAsyncAfter(seconds: delay) {
            DebugLog("DispatchQueue.backgroundAsyncAfter")
        }
    }
}
