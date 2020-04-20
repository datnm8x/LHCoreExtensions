//
//  Collection+Ex.swift
//  Skeleton-MVVM-RxSwift
//
//  Created by Dat Ng on 12/4/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    // same as Distinct()
    // arrs = ["four","one", "two", "one", "three","four", "four"]
    // arrs.unique => ["four", "one", "two", "three"]
    var unique: [Element] {
        var alreadyAdded = Set<Iterator.Element>()
        return self.filter { alreadyAdded.insert($0).inserted }
    }
}

public extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    @discardableResult
    mutating func remove(object: Element) -> Int? {
        if let index = firstIndex(of: object) {
            remove(at: index)
            return index
        }

        return nil
    }

    func indexOf(object: Element) -> Int? {
        guard (self as NSArray).contains(object) else { return nil }
        return (self as NSArray).index(of: object)
    }

    @discardableResult
    mutating func removeFirstSafe() -> Element? {
        guard self.count > 0 else { return nil }
        return self.removeFirst()
    }

    @discardableResult
    mutating func removeLastSafe() -> Element? {
        guard self.count > 0 else { return nil }
        return self.removeLast()
    }
}

public extension Array where Element: StringProtocol {
    var filterEmpty: [Element] {
        return self.filter({ (item) -> Bool in
            return !item.isEmpty
        })
    }
}
