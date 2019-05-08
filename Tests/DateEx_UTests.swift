//
//  DateEx_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 4/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class DateEx_UTests: XCTestCase {
    
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
        let dateTest = Date()
        _ = dateTest.toStringFormat8601()
        _ = dateTest.toStringJpTimeZone(format: "yyyy/mm/dd")
        _ = dateTest.toString(format: "yyyy/mm/dd")
        expect(dateTest.isFirstDayOfMonth).to(beFalse())
        expect(dateTest.isLastDayOfMonth).to(beFalse())
        expect(dateTest.isFirstMonthOfYear).to(beFalse())
        
        let dateTestFirst = "1/1/2019".toDate(withFormat: "d/m/yyyy")
        let dateTestLast = "31/1/2019".toDate(withFormat: "d/m/yyyy")
        expect(dateTestFirst?.isFirstDayOfMonth).to(beTrue())
        expect(dateTestLast?.isLastDayOfMonth).to(beTrue())
        expect(dateTestFirst?.isFirstMonthOfYear).to(beTrue())
        
        _ = dateTest.day
        _ = dateTest.month
        _ = dateTest.year
        _ = dateTest.hour
        _ = dateTest.minute
        _ = dateTest.second
        expect(dateTest.isToday).to(beTrue())
        expect(dateTest.isEqualDateIgnoreTime(toDate: Date())).to(beTrue())
        expect(dateTest.isEqualDateIgnoreTime(toDate: dateTestFirst)).to(beFalse())
        expect(dateTest.isEqualDateIgnoreTime(toDate: nil)).to(beFalse())
        expect(dateTestFirst?.addingDays(1).day).to(equal(2))
    }
}
