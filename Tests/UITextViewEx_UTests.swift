//
//  UITextViewEx_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 5/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class UITextViewEx_UTests: XCTestCase {

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
        let textViewTest = UITextView()

        var result = textViewTest.shouldChangeTextInRangeWithMaxLength(maxLength: 2, shouldChangeTextInRange: NSRange(location: 0, length: 0), replacementText: "ab")
        expect(result.0) == true

        result = textViewTest.shouldChangeTextInRangeWithMaxLength(maxLength: 2, shouldChangeTextInRange: NSRange(location: 0, length: 0), replacementText: "abc")
        expect(result.0) == false

        textViewTest.text = "abc"

        result = textViewTest.shouldChangeTextInRangeWithMaxLength(maxLength: 2, shouldChangeTextInRange: NSRange(location: 1, length: 0), replacementText: "")
        expect(result.0) == false
    }
}
