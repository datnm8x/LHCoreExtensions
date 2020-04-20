//
//  UITextView_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 5/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class UITextFieldEx_UTests: XCTestCase {

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
        let textFieldTest = BaseTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        textFieldTest.textColor = UIColor(hexCss: 0xFF0000)
        textFieldTest.text = nil
        var result = textFieldTest.shouldChangeCharactersInRange(withMaxLength: 2, inRange: NSRange(location: 0, length: 0), replacementString: "ab")
        expect(result.0) == true

        result = textFieldTest.shouldChangeCharactersInRange(withMaxLength: 2, inRange: NSRange(location: 0, length: 0), replacementString: "abc")
        expect(result.0) == false

        textFieldTest.text = "abc"

        result = textFieldTest.shouldChangeCharactersInRange(withMaxLength: 2, inRange: NSRange(location: 1, length: 0), replacementString: "")
        expect(result.0) == false

        textFieldTest.text = ""
        var numericCheck = textFieldTest.shouldChangeCharactersInRange(numericType: NumericType.Float, maxValue: 999, maxFractionDigits: 1, inRange: NSRange(location: 0, length: 0), replacementString: "999")
        expect(numericCheck) == true

        numericCheck = textFieldTest.shouldChangeCharactersInRange(numericType: NumericType.Float, maxValue: 999, maxFractionDigits: nil, inRange: NSRange(location: 0, length: 0), replacementString: "")
        expect(numericCheck) == true

        numericCheck = textFieldTest.shouldChangeCharactersInRange(numericType: NumericType.Float, maxValue: nil, maxFractionDigits: 1, inRange: NSRange(location: 0, length: 0), replacementString: "999")
        expect(numericCheck) == true

        numericCheck = textFieldTest.shouldChangeCharactersInRange(numericType: NumericType.Float, maxValue: 999, maxFractionDigits: 1, inRange: NSRange(location: 0, length: 0), replacementString: "9999")
        expect(numericCheck) == false

        numericCheck = textFieldTest.shouldChangeCharactersInRange(numericType: NumericType.Float, maxValue: 999.9, maxFractionDigits: 1, inRange: NSRange(location: 0, length: 0), replacementString: "999.9")
        expect(numericCheck) == true

        numericCheck = textFieldTest.shouldChangeCharactersInRange(numericType: NumericType.Float, maxValue: 999, maxFractionDigits: 1, inRange: NSRange(location: 0, length: 0), replacementString: "abc")
        expect(numericCheck) == false

        expect("abc".toFloat()).to(beNil())

        expect("abc".toInt()).to(beNil())
        expect("abc".toDouble()).to(beNil())

        expect("123".toInt()) == 123
        expect("123".toDouble()) == 123

        textFieldTest.disableActionEvents = .all
        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.paste(_:)), withSender: nil)) == false

        textFieldTest.disableActionEvents = [.paste, .copy, .select, .selectAll, .delete]
        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.paste(_:)), withSender: nil)) == false

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.copy(_:)), withSender: nil)) == false

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.select(_:)), withSender: nil)) == false

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.selectAll(_:)), withSender: nil)) == false

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.delete(_:)), withSender: nil)) == false

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.cut(_:)), withSender: nil)) == true

        textFieldTest.disableActionEvents = .none
        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.paste(_:)), withSender: nil)) == false

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.copy(_:)), withSender: nil)) == true

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.select(_:)), withSender: nil)) == true

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.selectAll(_:)), withSender: nil)) == true

        expect(textFieldTest.canPerformAction(#selector(UIResponderStandardEditActions.delete(_:)), withSender: nil)) == false

        textFieldTest.text = "textFieldTest"
        _ = textFieldTest.textRect(forBounds: CGRect(x: 0, y: 0, width: 20, height: 30))
        _ = textFieldTest.placeholderRect(forBounds: CGRect(x: 0, y: 0, width: 20, height: 30))
        _ = textFieldTest.editingRect(forBounds: CGRect(x: 0, y: 0, width: 20, height: 30))

        // Note: These must be written in UITest
        textFieldTest.rightString = nil
        textFieldTest.rightString = ""
        textFieldTest.rightString = "Done"
    }
}
