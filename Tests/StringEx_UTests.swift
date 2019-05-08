//
//  StringEx_UTests.swift
//  LHCoreExtensions_Tests
//
//  Created by Dat Ng on 5/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LHCoreExtensions
@testable import Example

import Nimble

class StringEx_UTests: XCTestCase {
    
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
        var stringTest = "StringEx_UTests"
        expect(stringTest.nsString.length) == 15
        expect(stringTest.trimWhiteSpace) == "StringEx_UTests"
        expect(stringTest.trimWhiteSpaceAndNewLine) == "StringEx_UTests"
        expect(stringTest.indexOffset(1).utf16Offset(in: stringTest)) == 1
        expect(stringTest[1]) == "t"
        expect(stringTest[15]) == ""
        expect(stringTest.appendingPathComponent(nil)) == "StringEx_UTests"
        expect(stringTest.appendingPathComponent("Path")) == "StringEx_UTests/Path"
        expect(stringTest.appendingPathExtension(nil)) == "StringEx_UTests"
        expect(stringTest.appendingPathExtension("test")) == "StringEx_UTests.test"
        expect(stringTest.indexOf(target: "Path")) == -1
        expect(stringTest.indexOf(target: "StringEx")) == 0
        expect(stringTest.indexOf(target: "Ex")) == 6
        expect(String.isEmpty(nil)) == true
        expect(String.isEmpty(stringTest)) == false
        expect(String.isEmpty("")) == true
        
        expect("2019/05/03".toDate(withFormat: "yyyy/MM/dd")).toNot(beNil())
        expect("2019/03".toDate(withFormat: "yyyy/MM/dd")).to(beNil())
        
        expect("2019-05-03T09:59:45Z".toDateFormat8601()).toNot(beNil())
        expect("2019/03".toDateFormat8601()).to(beNil())
        DebugLog(stringTest.getDynamicHeight(withFont: UIFont.systemFont(ofSize: 18)))
        
        stringTest.stringByDeleteCharactersInRange(NSRange(location: 0, length: 6))
        expect(stringTest) == "Ex_UTests"
        
        expect(stringTest.stringByDeletePrefix(nil)) == "Ex_UTests"
        expect(stringTest.stringByDeletePrefix("Str")) == "Ex_UTests"
        expect(stringTest.stringByDeletePrefix("Ex_")) == "UTests"
        
        stringTest = "StringEx_UTests"
        
        expect(stringTest.stringByDeleteSuffix(nil)) == "StringEx_UTests"
        expect(stringTest.stringByDeleteSuffix("Str")) == "StringEx_UTests"
        expect(stringTest.stringByDeleteSuffix("UTests")) == "StringEx_"
        
        expect(stringTest.deleteSuffix(20)) == "StringEx_UTests"
        expect(stringTest.deleteSuffix(6)) == "StringEx_"
        
        stringTest = "StringEx_UTests"
        expect(stringTest.deleteSub("_")) == "StringExUTests"
        
        expect(stringTest.getRanges(of: "")).to(beNil())
        expect(stringTest.getRanges(of: nil)).to(beNil())
        expect(stringTest.getRanges(of: "s")).toNot(beNil())
        
        expect(stringTest.rangesOfString("").count) == 0
        expect(stringTest.rangesOfString("s").count) == 2
        
        expect(stringTest.isValidEmail) == false
        expect("laohac83x@gmail.com".isValidEmail) == true
        
        expect(stringTest.addSpaces(3)) == "StringEx_UTests"
        expect(stringTest.addSpaces(18)) == "StringEx_UTests   "
        
        expect(stringTest.int).to(beNil())
        expect("123,3".int) == 1233
        
        expect(stringTest.int64).to(beNil())
        expect(stringTest.intValue) == 0
        expect(stringTest.int64Value) == 0
        
        expect("123,3".intValue) == 1233
        expect("123,3".int64Value) == 1233
        
        expect(stringTest.writeToDocument("")) == false
        expect(stringTest.writeToDocument("test.txt")) == true
        
        expect(stringTest.isValidUrl) == false
        expect("https://www.google.com.vn/".isValidUrl) == true
        
        DebugLog("https://www.google.com.vn/".encodeUrlPercentEncoding)
        
        let mutableString = NSMutableAttributedString(string: "https://www.google.com.vn/")
        mutableString.addFont(font: UIFont.systemFont(ofSize: 18), for: "https")
        mutableString.addFont(font: UIFont.systemFont(ofSize: 18), for: "ABC")
        
        mutableString.addTextColor(color: UIColor.red, for: "https")
        mutableString.addTextColor(color: UIColor.red, for: "ABC")
        
        mutableString.addFont(font: UIFont.systemFont(ofSize: 18), forSubs: "o")
        mutableString.addFont(font: UIFont.systemFont(ofSize: 18), forSubs: "")
        
        mutableString.addTextColor(color: UIColor.red, forSubs: "o")
        mutableString.addTextColor(color: UIColor.red, forSubs: "ABC")
    }
}
