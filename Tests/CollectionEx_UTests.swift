//
//  CollectionEx_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 4/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class CollectionEx_UTests: XCTestCase {
    
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
        var arrTest = [1,2,3,4]
        arrTest.remove(object: 5)
        expect(arrTest.count) == 4

        arrTest.remove(object: 4)
        expect(arrTest.count) == 3
        
        expect(arrTest.indexOf(object: 1)) == 0
        expect(arrTest.indexOf(object: 5)).to(beNil())
        
        expect(arrTest.removeFirstSafe()) == 1
        expect(arrTest.removeLastSafe()) == 3
        
        arrTest.removeAll()
        
        expect(arrTest.removeFirstSafe()).to(beNil())
        expect(arrTest.removeLastSafe()).to(beNil())
    }
}
