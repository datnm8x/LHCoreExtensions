//
//  UIViewEx_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 4/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class UIViewEx_UTests: XCTestCase {

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
        let testView = CustomViewTest.fromNib()!
        testView.xFrame = 0
        testView.yFrame = 0
        testView.height = 200
        testView.width = 200

        expect(testView.xFrame).to(equal(0))
        expect(testView.yFrame).to(equal(0))
        expect(testView.height).to(equal(200))
        expect(testView.width).to(equal(200))

        testView.borderColor = nil
        expect(testView.borderColor).to(beNil())

        testView.cornerRadius = 10
        testView.borderWidth = 10
        testView.borderColor = UIColor.red
        testView.setCornerRadius(cornerRadius: 10, borderWidth: 10, borderColor: UIColor.red)

        expect(testView.cornerRadius).to(equal(10))
        expect(testView.borderWidth).to(equal(10))
        expect(testView.borderColor).to(equal(UIColor.red))

        expect(CustomViewTest.nib).to(beAKindOf(UINib.classForCoder()))

        expect(CustomViewTest.fromNib(nibNameOrNil: "TestNil")).to(beNil())

        expect(CustomViewTestNil.nib).to(beNil())

        let layerTest = CALayer()
        layerTest.borderUIColor = nil
        expect(layerTest.borderUIColor).to(beNil())
        layerTest.borderUIColor = UIColor.red
        expect(layerTest.borderUIColor).to(equal(UIColor.red))

        _ = testView.captured(withScale: 2.0)
        testView.rotate(degree: 90, duration: 1.0)

        expect(testView.parentViewController).to(beNil())
        expect(CustomViewTest.fromNib(nibNameOrNil: "TestViewNil")).to(beNil())
    }
}
