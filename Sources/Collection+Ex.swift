//
//  Collection+Ex.swift
//  Skeleton-MVVM-RxSwift
//
//  Created by Dat Ng on 12/4/18.
//  Copyright © 2018 datnm. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
    func indexOf(object: Element) -> Int? {
        guard (self as NSArray).contains(object) else { return nil }
        return (self as NSArray).index(of: object)
    }
    
    mutating func removeFirstSafe() -> Element? {
        guard self.count > 0 else { return nil }
        return self.removeFirst()
    }
    
    mutating func removeLastSafe() -> Element? {
        guard self.count > 0 else { return nil }
        return self.removeLast()
    }
}
