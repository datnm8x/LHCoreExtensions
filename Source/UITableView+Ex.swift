//
//  UITableView+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    func layoutSizeFittingHeaderView(_ width: CGFloat? = nil) {
        guard let viewFitting = self.tableHeaderView else { return }
        
        let fitWidth = width ?? self.frame.width
        
        viewFitting.translatesAutoresizingMaskIntoConstraints = false
        // [add subviews and their constraints to view]
        let widthConstraint = NSLayoutConstraint(item: viewFitting, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fitWidth)
        widthConstraint.isActive = true
        
        viewFitting.addConstraint(widthConstraint)
        viewFitting.setNeedsLayout()
        viewFitting.layoutIfNeeded()
        let fittingHeight = viewFitting.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        viewFitting.removeConstraint(widthConstraint)
        widthConstraint.isActive = false
        
        viewFitting.frame = CGRect(x: 0, y: 0, width: fitWidth, height: fittingHeight)
        viewFitting.translatesAutoresizingMaskIntoConstraints = true
        
        self.tableHeaderView = viewFitting
    }
    
    func layoutSizeFittingFooterView(_ width: CGFloat? = nil) {
        guard let viewFitting = self.tableFooterView else { return }
        
        let fitWidth = width ?? self.frame.width
        
        viewFitting.translatesAutoresizingMaskIntoConstraints = false
        // [add subviews and their constraints to view]
        let widthConstraint = NSLayoutConstraint(item: viewFitting, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fitWidth)
        widthConstraint.isActive = true
        
        viewFitting.addConstraint(widthConstraint)
        viewFitting.setNeedsLayout()
        viewFitting.layoutIfNeeded()
        let fittingHeight = viewFitting.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        viewFitting.removeConstraint(widthConstraint)
        widthConstraint.isActive = false
        
        viewFitting.frame = CGRect(x: 0, y: 0, width: fitWidth, height: fittingHeight)
        viewFitting.translatesAutoresizingMaskIntoConstraints = true
        
        self.tableFooterView = viewFitting
    }
    
    func setTableHeaderViewLayoutSizeFitting(_ headerView: UIView) {
        self.tableHeaderView = headerView
        self.layoutSizeFittingHeaderView()
    }
    
    func setTableFooterViewLayoutSizeFitting(_ footerView: UIView) {
        self.tableFooterView = footerView
        self.layoutSizeFittingFooterView()
    }
    
    func makeHeaderLeastNonzeroHeight() {
        let tempHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: CGFloat.leastNonzeroMagnitude))
        self.tableHeaderView = tempHeaderView
    }
    
    func makeFooterLeastNonzeroHeight() {
        let tempHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: CGFloat.leastNonzeroMagnitude))
        self.tableFooterView = tempHeaderView
    }
    
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row >= 0 && indexPath.section >= 0 && indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToLastRow(animated: Bool = true, atScrollPosition: UITableView.ScrollPosition = .bottom) {
        let section = self.numberOfSections - 1
        guard section >= 0 else { return }
        let row = self.numberOfRows(inSection: section) - 1
        guard row >= 0, self.isValidIndexPath(IndexPath(row: row, section: section)) else { return }
        
        self.scrollToRow(at: IndexPath(row: row, section: section), at: atScrollPosition, animated: animated)
    }
    
    func scrollToCell(_ toCell: UITableViewCell?, animated: Bool = true, atScrollPosition: UITableView.ScrollPosition = .bottom) {
        guard let cell = toCell else { return }
        guard let indexPath = self.indexPath(for: cell), self.isValidIndexPath(indexPath) else { return }
        
        self.scrollToRow(at: indexPath, at: atScrollPosition, animated: animated)
    }
    
    func isLastIndexPath(_ indexPath: IndexPath) -> Bool {
        return (indexPath.section == self.numberOfSections - 1) && (indexPath.row == self.numberOfRows(inSection: indexPath.section) - 1)
    }
    
    func setSeparatorNoneForNoCells() {
        let footerV = UIView()
        footerV.backgroundColor = self.backgroundColor ?? UIColor.white
        self.tableFooterView = footerV
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.reloadData()
        CATransaction.commit()
    }
    
    func reloadDataWithResetOffset() {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.allowAnimatedContent, animations: { [weak self] in
            self?.contentOffset = CGPoint.zero
        }) { [weak self] (finish) in
            self?.reloadData()
        }
    }
}

public extension UITableViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
    
    var parentTableView: UITableView? {
        var parentView: UIView? = self.superview
        while (parentView != nil && (parentView as? UITableView) == nil) {
            parentView = parentView?.superview
        }
        
        return parentView  as? UITableView
    }
    
    func setSeparatorFullWidth() {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    func setSeparatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = edgeInsets
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    func setSeparatorInsetsEdges(left: CGFloat, right: CGFloat) {
        var edgeInsets = UIEdgeInsets.zero
        edgeInsets.left = left
        edgeInsets.right = right
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = edgeInsets
        self.layoutMargins = UIEdgeInsets.zero
    }
}

public extension UIView {
    var parentTableViewCell: UITableViewCell? {
        var parentView: UIView? = self.superview
        while (parentView != nil && (parentView as? UITableViewCell) == nil) {
            parentView = parentView?.superview
        }
        
        return parentView  as? UITableViewCell
    }
    
    var parentCollectionViewCell: UICollectionViewCell? {
        var parentView: UIView? = self.superview
        while (parentView != nil && (parentView as? UICollectionViewCell) == nil) {
            parentView = parentView?.superview
        }
        
        return parentView  as? UICollectionViewCell
    }
}

open class BaseTableView: UITableView {
    override open func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard self.isValidIndexPath(indexPath) else { return }
        
        super.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    open var onTouchBeganEvent: (() -> ())?
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.onTouchBeganEvent?()
    }
    
    override open func performBatchUpdates(_ updates: (() -> Swift.Void)?, completion: ((Bool) -> Swift.Void)? = nil) {
        if #available(iOS 11, *) {
            super.performBatchUpdates(updates, completion: completion)
        } else {
            guard let updateBlock = updates else {
                completion?(false)
                return
            }
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if let completionBlock = completion {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        if Thread.isMainThread {
                            completionBlock(true)
                        } else {
                            DispatchQueue.main.async(execute: {
                                completionBlock(true)
                            })
                        }
                    }
                }
            }
            self.beginUpdates()
            updateBlock()
            self.endUpdates()
            CATransaction.commit()
        }
    }
}

public extension UICollectionView {
    var collectionViewFlowLayout: UICollectionViewFlowLayout? {
        return self.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.reloadData()
        CATransaction.commit()
    }
    
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.item >= 0 && indexPath.section >= 0 && indexPath.section < self.numberOfSections && indexPath.item < self.numberOfItems(inSection: indexPath.section)
    }
    
    func scrollToLastItem(animated: Bool = true, atScrollPosition: UICollectionView.ScrollPosition = .bottom) {
        let sectionIndex = self.numberOfSections - 1
        guard sectionIndex >= 0 else { return }
        let itemIndex = self.numberOfItems(inSection: sectionIndex) - 1
        let toIndexPath = IndexPath(item: itemIndex, section: sectionIndex)
        guard itemIndex >= 0, self.isValidIndexPath(toIndexPath) else { return }
        
        self.scrollToItem(at: toIndexPath, at: atScrollPosition, animated: animated)
    }
    
    func scrollToCell(_ toCell: UICollectionViewCell?, animated: Bool = true, atScrollPosition: UICollectionView.ScrollPosition = .bottom) {
        guard let cell = toCell else { return }
        guard let indexPath = self.indexPath(for: cell), self.isValidIndexPath(indexPath) else { return }
        
        self.scrollToItem(at: indexPath, at: atScrollPosition, animated: animated)
    }
    
    func isLastIndexPath(_ indexPath: IndexPath) -> Bool {
        return (indexPath.section == self.numberOfSections - 1) && (indexPath.item == self.numberOfItems(inSection: indexPath.section) - 1)
    }
}

open class BaseCollectionView: UICollectionView {
    
    override open var collectionViewLayout: UICollectionViewLayout {
        didSet {
            if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
                switch flowLayout.scrollDirection {
                case .horizontal:
                    self.alwaysBounceHorizontal = true
                default:
                    self.alwaysBounceVertical = true
                }
            }
        }
    }
    
    open var onTouchBeganEvent: (() -> ())?
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.onTouchBeganEvent?()
    }
}

public extension UICollectionViewCell {
    var parentCollectionView: UICollectionView? {
        var parentView: UIView? = self.superview
        while (parentView != nil && (parentView as? UICollectionView) == nil) {
            parentView = parentView?.superview
        }
        
        return parentView  as? UICollectionView
    }
}

public extension UIScrollView {
    func scrollToBottom(animated: Bool = true) {
        let offset = self.contentSize.height - self.bounds.size.height
        self.setContentOffset(CGPoint(x: 0, y: offset), animated: animated)
    }
}

open class BaseScrollView: UIScrollView {
    open var onTouchBeganEvent: (() -> ())?
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.onTouchBeganEvent?()
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String { return String(describing: self) }
}
