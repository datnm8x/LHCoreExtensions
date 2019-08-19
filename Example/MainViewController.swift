//
//  MainViewController.swift
//  LHCoreExtensions
//
//  Created by Dat Ng on 04/19/2019.
//  Copyright (c) 2019 laohac83x@gmail.com. All rights reserved.
//

import UIKit
import LHCoreExtensions

class MainViewController: LHBaseViewController {
    @IBOutlet weak var testCustomV: CustomViewTest!
    @IBOutlet weak var btnHandler: LHButtonHandler!
    @IBOutlet weak var mCollectionView: LHBaseCollectionView!
    @IBOutlet weak var mTableView: LHBaseTableView!
    
    var dataTest: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("".isValidPhone)
        print("098".isValidPhone)
        print("098 6345789".isValidPhone)
        print("+8498 6345789".isValidPhone)
        print("+8498 6345789a".isValidPhone)
        print("-8498 6345789".isValidPhone)
        print("098 6345".isValidPhone)
        
        var date = Date()
        date.year = 2017
        date.month = 2
        date.day = 31
        print(date)
        
        btnHandler.onClickedHandler = { [weak self] _ in
            guard let pushVC = PushViewController1.instanceStoryboard(UIStoryboard(name: "Main", bundle: nil)) else { return }
            self?.navigationController?.pushViewController(pushVC, animated: true)
        }
        
//        btnHandler.setBackgroundColor(UIColor.yellow, for: UIControl.State.normal)
//        btnHandler.isEnabled = false
        btnHandler.isSelected = true
        btnHandler.isHighlighted = true
        
        for index: Int in 0..<50 {
            dataTest.append("dataTest: \(index)")
        }
        mTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        
        testTableViewEx()
        testCollectionViewEx()
        testUIViewControllerEx()
        
        let arrs = ["Hanoi", "Bac Ninh Province", "Hanoi", "bắc giang", "Hanoi"]
        print(arrs.unique)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppearAtFirst(_ atFirst: Bool, animated: Bool) {
        super.viewWillAppearAtFirst(atFirst, animated: animated)
    }
    
    override func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) {
        super.viewDidAppearAtFirst(atFirst, animated: animated)
        
        if testCustomV.parentViewController == self {
            DebugLog("parentViewController is true")
        }
        
        _ = CustomViewTest.fromNib(nibNameOrNil: "TestNil")
        DebugLog(self.topBarsDistance)
        
        guard atFirst else { return }
        
        let date = Date(minuteInterval: 5)
        DebugLog(date.minute)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func testActionSelector() {
        
    }

    func testTableViewEx() {
        mTableView.reloadData {
            DebugLog("mTableView.reloadData")
        }
        
        mTableView.layoutSizeFittingHeaderView()
        mTableView.setTableHeaderViewLayoutSizeFitting(UIView())
        mTableView.layoutSizeFittingHeaderView(UIDevice.width)
        
        mTableView.layoutSizeFittingFooterView()
        mTableView.setTableFooterViewLayoutSizeFitting(UIView())
        mTableView.layoutSizeFittingFooterView(UIDevice.width)
        
        mTableView.makeHeaderLeastNonzeroHeight()
        mTableView.makeFooterLeastNonzeroHeight()
        
        _ = mTableView.isValidIndexPath(IndexPath(row: -1, section: 0))
        _ = mTableView.isValidIndexPath(IndexPath(row: 0, section: -1))
        _ = mTableView.isValidIndexPath(IndexPath(row: 0, section: 0))
        _ = mTableView.isValidIndexPath(IndexPath(row: dataTest.count + 1, section: 0))
        _ = mTableView.isValidIndexPath(IndexPath(row: 0, section: 2))
        
        mTableView.scrollToLastRow()
        mTableView.scrollToBottom()
        
        _ = mTableView.isLastIndexPath(IndexPath(row: 0, section: 0))
        _ = mTableView.isLastIndexPath(IndexPath(row: dataTest.count - 1, section: 1))
        _ = mTableView.isLastIndexPath(IndexPath(row: dataTest.count - 1, section: 0))
        
        mTableView.setSeparatorNoneForNoCells()
        
        mTableView.reloadDataWithResetOffset()
        mTableView.onTouchBeganEvent = {
            DebugLog("mTableView.onTouchBeganEvent")
        }
        mTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.middle, animated: true)
        mTableView.scrollToRow(at: IndexPath(row: 20, section: 1), at: UITableView.ScrollPosition.middle, animated: true)
    }
    
    func testCollectionViewEx() {
        _ = mCollectionView.collectionViewFlowLayout
        mCollectionView.reloadData {
            DebugLog("mCollectionView.reloadData")
        }
        
        mCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        mCollectionView.collectionViewLayout = flowLayout
        
        mCollectionView.onTouchBeganEvent = {
            DebugLog("mCollectionView.onTouchBeganEvent")
        }
    }
    
    func testUIViewControllerEx() {
        self.setLeftBarButtonItemCustom(image: "", target: self, action: #selector(testActionSelector))
        self.setLeftBarButtonItemCustom(title: "Test", target: self, action: #selector(testActionSelector))
        self.setLeftBarButtonItemCustom(image: "", maskColor: UIColor(hexCss: 0xFF0000)) { (button) in
            
        }
        self.setLeftBarButtonItemCustom(title: "Test", color: UIColor(hexCss: 0xFF0000)) { (button) in
            
        }
        
        self.setRightBarButtonItemCustom(image: "", target: self, action: #selector(testActionSelector))
        self.setRightBarButtonItemCustom(title: "Test", color: UIColor(hexCss: 0xFF0000), target: self, action: #selector(testActionSelector))
        
        self.setRightBarButtonItemCustom(image: "", maskColor: UIColor(hexCss: 0xFF0000)) { (button) in
            
        }
        
        self.setRightBarButtonItemCustom(title: "Test", color: UIColor(hexCss: 0xFF0000)) { (button) in
            
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier)!
        cell.textLabel?.text = dataTest[indexPath.row]
        cell.setSeparatorFullWidth()
        cell.setSeparatorInsets(UIEdgeInsets.zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DebugLog(cell.parentTableView == tableView)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellTest", for: indexPath) as! CollectionViewCellTest
        cell.textLabel.text = dataTest[indexPath.item]
        
        return cell
    }
}

class CollectionViewCellTest: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
}

