//
//  PushViewController.swift
//  Example
//
//  Created by Dat Ng on 5/22/19.
//  Copyright © 2019 Lao Hac. All rights reserved.
//

import Foundation
import UIKit
import LHCoreExtensions
import SnapKit

class PushViewController: BaseViewController {
    weak var beforeVC: UIViewController?
    var buttonAction: ButtonHandler = ButtonHandler(frame: CGRect(x: 20, y: 150, width: 300, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = String(describing: self)
        buttonAction.setTitle("Push Action", for: UIControl.State.normal)
        buttonAction.setTitleColor(UIColor.brown, for: UIControl.State.normal)
        self.view.addSubview(buttonAction)
        
        buttonAction.snp.makeConstraints { (constraint) in
            constraint.width.equalTo(280)
            constraint.height.equalTo(50)
            constraint.center.equalToSuperview()
        }
    }
}

class PushViewController1: PushViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction.onClickedHandler = { [weak self] _ in
            guard let pushVC = PushViewController2.instanceStoryboard(UIStoryboard(name: "Main", bundle: nil)) else { return }
            self?.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
}


class PushViewController2: PushViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction.onClickedHandler = { [weak self] _ in
            guard let pushVC = PushViewController3.instanceStoryboard(UIStoryboard(name: "Main", bundle: nil)) else { return }
            self?.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
}

class PushViewController3: PushViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction.onClickedHandler = { [weak self] _ in
            guard let pushVC = PushViewController4.instanceStoryboard(UIStoryboard(name: "Main", bundle: nil)) else { return }
            
            pushVC.beforeVC = self
            self?.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
}

class PushViewController4: PushViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction.onClickedHandler = { [weak self] _ in
            guard let pushVC = PushViewController5.instanceStoryboard(UIStoryboard(name: "Main", bundle: nil)) else { return }
            pushVC.beforeVC = self?.beforeVC
            self?.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
}

class PushViewController5: PushViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction.onClickedHandler = { [weak self] _ in
            
            if let mBeforeVC = self?.beforeVC {
                self?.navigationController?.pushToViewControllerBefore(mBeforeVC, animated: true, completion: {
                    print("pushToViewControllerBefore")
                })
            } else if let pushVC = PushViewController6.instanceStoryboard(UIStoryboard(name: "Main", bundle: nil)) {
                self?.navigationController?.pushViewControllerAndRemoveBefores(pushVC, animated: true, completion: {
                    DebugLog("pushViewControllerAndRemoveBefores")
                })
            }
        }
    }
}

class PushViewController6: PushViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction.onClickedHandler = { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
