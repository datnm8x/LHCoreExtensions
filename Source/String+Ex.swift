//
//  String+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

public extension String {
    var nsString: NSString { return self as NSString }
    var length: Int { return self.nsString.length }
    var trimWhiteSpace: String { return self.trimmingCharacters(in: .whitespaces) }
    var trimWhiteSpaceAndNewLine: String { return self.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    func indexOffset(_ by: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: by)
    }
    
    subscript (index: Int) -> String {
        let indexBy = indexOffset(index)
        guard indexBy < self.endIndex else { return "" }
        return String(self[indexBy])
    }
    
    func appendingPathComponent(_ pathComponent: String?) -> String {
        guard let pathComponent = pathComponent else {
            return self
        }
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    func appendingPathExtension(_ pathExtension: String?) -> String {
        guard let pathExtension = pathExtension else {
            return self
        }
        return (self as NSString).appendingPathExtension(pathExtension) ?? self
    }
    
    func indexOf(target: String) -> Int {
        if let range = self.range(of: target) {
            return self.distance(from: startIndex, to: range.lowerBound)
        }
        return -1
    }
    
    static func isEmpty(_ string: String?, trimCharacters: CharacterSet = CharacterSet(charactersIn: "")) -> Bool {
        if (string == nil) { return true }
        return string!.trimmingCharacters(in: trimCharacters) == ""
    }
    
    func toDate(withFormat formatDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        return dateFormatter.date(from: self)
    }
    
    func toDateFormat8601() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    
    func getDynamicHeight(withFont: UIFont) -> CGFloat {
        return self.nsString.size(withAttributes: [NSAttributedString.Key.font: withFont]).height
    }
    
    mutating func stringByDeleteCharactersInRange(_ range: NSRange) {
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        self.removeSubrange(startIndex ..< endIndex)
    }
    
    func stringByDeletePrefix(_ prefix: String?) -> String {
        if let prefixString = prefix, self.hasPrefix(prefixString) {
            return self.nsString.substring(from: prefixString.length)
        }
        return self
    }
    
    func stringByDeleteSuffix(_ suffix: String?) -> String {
        if let suffixString = suffix, self.hasSuffix(suffixString) {
            return self.nsString.substring(to: self.length - suffixString.length)
        }
        return self
    }
    
    func deleteSuffix(_ suffix: Int) -> String {
        if suffix >= self.length {
            return self
        }
        return self.nsString.substring(to: self.length - suffix)
    }
    
    func deleteSub(_ subStringToDelete: String) -> String {
        return self.replacingOccurrences(of: subStringToDelete, with: "")
    }
    
    func getRanges(of: String?) -> [NSRange]? {
        guard let ofString = of, String.isEmpty(ofString) == false else {
            return nil
        }
        
        do {
            let regex = try NSRegularExpression(pattern: ofString)
            return regex.matches(in: self, range: NSRange(location: 0, length: self.length)).map({ (textCheckingResult) -> NSRange in
                return textCheckingResult.range
            })
        } catch {
            let range = self.nsString.range(of: ofString)
            if range.location != NSNotFound {
                var ranges = [NSRange]()
                ranges.append(range)
                let remainString = self.nsString.substring(from: range.location + range.length)
                if let rangesNext = remainString.getRanges(of: ofString) {
                    ranges.append(contentsOf: rangesNext)
                }
                return ranges
            } else {
                return nil
            }
        }
    }
    
    func rangesOfString(_ ofString: String, options: NSString.CompareOptions = [], searchRange: Range<Index>? = nil ) -> [Range<Index>] {
        if let range = self.range(of: ofString, options: options, range: searchRange, locale: nil) {
            let nextRange: Range = range.upperBound..<self.endIndex
            return [range] + rangesOfString(ofString, searchRange: nextRange)
        }
        return []
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailCheck.evaluate(with: self)
    }
    
    func addSpaces(_ forMaxLenght: Int) -> String {
        if self.length >= forMaxLenght { return self }
        var result = self
        for _ in 0..<(forMaxLenght - self.length) {
            result.append(" ")
        }
        return result
    }
    
    var int: Int? { return Int(self.deleteSub(",")) }
    var int64: Int64? { return Int64(self.deleteSub(",")) }
    var intValue: Int { return Int(self.deleteSub(",")) ?? 0 }
    var int64Value: Int64 { return Int64(self.deleteSub(",")) ?? 0 }
    
    @discardableResult
    func writeToDocument(_ fileName: String) -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            //writing
            do {
                try self.write(to: fileURL, atomically: false, encoding: .utf8)
                return true
            } catch { /* error handling here */ }
        }
        return false
    }
    
    var isValidUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return !String.isEmpty(url.scheme) && !String.isEmpty(url.host)
    }
    
    var encodeUrlPercentEncoding: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
}

public extension NSMutableAttributedString {
    func addFont(font: UIFont, for subString: String?) {
        guard let forSubString = subString, String.isEmpty(forSubString) == false else { return }
        let rangeOfSub = self.string.nsString.range(of: forSubString)
        if rangeOfSub.location != NSNotFound {
            self.addAttributes([NSAttributedString.Key.font: font], range: rangeOfSub)
        } else {
            // not proccess
        }
    }
    
    func addTextColor(color: UIColor, for subString: String?) {
        guard let forSubString = subString, String.isEmpty(forSubString) == false else { return }
        let rangeOfSub = self.string.nsString.range(of: forSubString)
        if rangeOfSub.location != NSNotFound {
            self.addAttributes([NSAttributedString.Key.foregroundColor: color], range: rangeOfSub)
        } else {
            // not proccess
        }
    }
    
    func addFont(font: UIFont, forSubs subString: String?) {
        self.string.getRanges(of: subString)?.forEach({ (range) in
            if range.location != NSNotFound {
                self.addAttributes([NSAttributedString.Key.font: font], range: range)
            } else {
                // not proccess
            }
        })
    }
    
    func addTextColor(color: UIColor, forSubs subString: String?) {
        self.string.getRanges(of: subString)?.forEach({ (range) in
            if range.location != NSNotFound {
                self.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
            } else {
                // not proccess
            }
        })
    }
}
