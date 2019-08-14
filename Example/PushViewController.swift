//
//  PushViewController.swift
//  Example
//
//  Created by Dat Ng on 5/22/19.
//  Copyright © 2019 Lao Hac. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PushViewController: LHBaseViewController {
    weak var beforeVC: UIViewController?
    var buttonAction: LHButtonHandler = LHButtonHandler(frame: CGRect(x: 20, y: 150, width: 300, height: 44))
    
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
    @IBOutlet weak var testCornerView: LHEffectView!
    @IBOutlet weak var testGradientView: LHEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction.onClickedHandler = { [weak self] _ in
            guard let pushVC = PushViewController2.instanceStoryboard(UIStoryboard(name: "Main", bundle: nil)) else { return }
            self?.navigationController?.pushViewController(pushVC, animated: true)
        }
        
        testCornerView.backgroundColor = .lightGray
        testCornerView.cornersAt = UIRectCorner.topLeft.union(.topRight)
        testCornerView.cornerRadius = 15
    }
    
    override func viewDidAppearAtFirst(_ atFirst: Bool, animated: Bool) {
        super.viewDidAppearAtFirst(atFirst, animated: animated)
        guard atFirst else { return }
        
        testGradientView.direction = .position((startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1)))
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

class TestCornerView: UIView {
    private var pCornerRadius: CGFloat = 0.0
    private var pBorderWidth: CGFloat = 0.0
    private var pBorderColor: UIColor?
    open var cornersAt: UIRectCorner = .allCorners {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func setCornerRadiusTest(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        pCornerRadius = cornerRadius
        pBorderWidth = borderWidth
        pBorderColor = borderColor
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornersAt, cornerRadii: CGSize(width: pCornerRadius, height: pCornerRadius))
        path.lineWidth = pBorderWidth
        pBorderColor?.setStroke()
        path.stroke()
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        maskLayer.strokeColor = pBorderColor?.cgColor

        self.layer.mask = maskLayer
    }
}

