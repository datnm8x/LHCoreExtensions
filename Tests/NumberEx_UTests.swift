//
//  NumberEx_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 4/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class NumberEx_UTests: XCTestCase {
    
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
        let numberInt: Int = 6666
        
        expect(numberInt.toString()).to(equal("6666"), description: "No separator")
        expect(numberInt.toString(separator: ",")).to(equal("6,666"), description: "Separator: ','")
        
        let numberInt64: Int64 = 6666
        expect(numberInt64.toString()).to(equal("6666"), description: "No separator")
        expect(numberInt64.toString(separator: ",")).to(equal("6,666"), description: "Separator: ','")
        expect(LocalizedString("Test")).to(equal("Test"), description: "Unknown LocalizedString")
        DebugLog(LocalizedString("Test"), "Unknown LocalizedString")
    }
}
