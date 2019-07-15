//
//  UITextView+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
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

open class LHBaseTextView: UITextView {
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.alpha = 1.0
        
        return label
    }()
    
    @IBInspectable
    open var placeholderColor: UIColor = UIColor.lightGray.withAlphaComponent(0.7) {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    @IBInspectable
    open var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            handlePlaceholderLabel()
        }
    }
    
    override open var text: String! {
        didSet {
            textChanged(nil)
        }
    }
    
    override open var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    var constraintsPlaceHolder: [NSLayoutConstraint]!
    fileprivate func commonInit() {
        let cFont = self.font ?? UIFont.systemFont(ofSize: 14.0)
        self.font = cFont
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.text = placeholder
        
        addSubview(placeholderLabel)
        
        let constraints = [
            NSLayoutConstraint(item: placeholderLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: contentInset.left + textContainerInset.left),
            NSLayoutConstraint(item: placeholderLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: contentInset.right + textContainerInset.right),
            NSLayoutConstraint(item: placeholderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: contentInset.bottom + textContainerInset.bottom),
        ]
        self.addConstraints(constraints)
        constraintsPlaceHolder = constraints
        
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(LHBaseTextView.textChanged(_:)),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
        
        textChanged(nil)
    }
    
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            relayoutPlaceHolder()
        }
    }
    
    open override var contentInset: UIEdgeInsets {
        didSet {
            relayoutPlaceHolder()
        }
    }
    
    func relayoutPlaceHolder() {
        constraintsPlaceHolder?.forEach({ (constraint) in
            switch constraint.firstAttribute {
            case .left:
                constraint.constant = contentInset.left + textContainerInset.left
            case .right:
                constraint.constant = contentInset.right + textContainerInset.right
            case .top:
                constraint.constant = contentInset.top + textContainerInset.top
            default: break
            }
        })
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        commonInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    @objc func textChanged(_ notification:Notification?) {
        handlePlaceholderLabel()
    }
    
    func handlePlaceholderLabel() {
        placeholderLabel.isHidden = !String.isEmpty(text)
    }
}
