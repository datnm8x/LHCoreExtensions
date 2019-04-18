//
//  UITextView+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
    func shouldChangeTextInRangeWithMaxLength(maxLenght: Int, shouldChangeTextInRange range: NSRange, replacementText text: String) -> (Bool, String?) {
        var result: Bool = true
        let commentInput = text as NSString
        let maximumCommentLenght = maxLenght
        var resultString: String?
        if (commentInput.length > 1) {
            // paste event
            var textControl: NSString = (self.text as NSString).replacingCharacters(in: range, with: text) as NSString
            if (textControl.length > maximumCommentLenght) {
                var rangeEnum: NSRange = NSMakeRange(maximumCommentLenght - 2, 4)
                if(rangeEnum.location + rangeEnum.length > textControl.length) {
                    rangeEnum.length = textControl.length - rangeEnum.location
                }
                var maxTextInputAvaiable: NSInteger = maximumCommentLenght
                textControl.enumerateSubstrings(in: rangeEnum, options: NSString.EnumerationOptions.byComposedCharacterSequences) { (substring, substringRange, enclosingRange, stop) -> () in
                    if(substringRange.location + substringRange.length <= maximumCommentLenght) {
                        maxTextInputAvaiable = substringRange.location + substringRange.length
                    }
                }
                textControl = textControl.substring(to: maxTextInputAvaiable) as NSString
                resultString = textControl as String
                result = false
            }
        } else {
            // press keyboard / typing
            if (range.length <= 0) {
                let textControl: NSString = (self.text as NSString).replacingCharacters(in: range, with: text) as NSString
                result = textControl.length <= maximumCommentLenght
            }
        }
        
        return (result, resultString)
    }
}
