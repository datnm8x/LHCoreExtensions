//
//  DialogHandler.swift
//  Base Utils
//
//  Created by Dat Ng on 2/23/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

class DialogHandler {
    @discardableResult
    fileprivate class func showAlert(title: String? = nil, message: String?,
                                     button: String = "OK",
                                     tintColor: UIColor? = nil,
                                     onVC: UIViewController? = nil, buttonHandler:(() -> Void)? = nil) -> UIAlertController? {
        if (String.isEmpty(title, characterSet: .whitespacesAndNewlines) && String.isEmpty(message, characterSet: .whitespacesAndNewlines)) || String.isEmpty(button, characterSet: .whitespacesAndNewlines) {
            return nil
        }
        
        if let onPresentController = onVC ?? UIApplication.shared.keyWindow?.rootViewController?.topMostViewController {
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertViewController.addAction(UIAlertAction(title: button, style: .default, handler: { (alertAction) in
                buttonHandler?()
            }))
            
            if let tinColor = tintColor { alertViewController.view.tintColor = tinColor }
            onPresentController.present(alertViewController, animated: true, completion: nil)
            return alertViewController
        }
        
        return nil
    }

    @discardableResult
    class func showDialogConfirm(title: String? = nil, message: String?,
                          btnOK: String = "OK", btnCancel: String = "Cancel",
                          tintColor: UIColor? = nil,
                          onVC: UIViewController? = nil, buttonHandler:((String) -> Void)? = nil) -> UIAlertController? {
        
        if (String.isEmpty(title, characterSet: .whitespacesAndNewlines) && String.isEmpty(message, characterSet: .whitespacesAndNewlines)) {
            return nil
        }
        
        if (String.isEmpty(btnOK, characterSet: .whitespacesAndNewlines) && String.isEmpty(btnCancel, characterSet: .whitespacesAndNewlines)) {
            return nil
        }
        
        if let onPresentController = onVC ?? UIApplication.shared.keyWindow?.rootViewController?.topMostViewController {
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertViewController.addAction(UIAlertAction(title: btnOK, style: .default, handler: { (alertAction) in
                buttonHandler?(btnOK)
            }))
            
            alertViewController.addAction(UIAlertAction(title: btnCancel, style: .default, handler: { (alertAction) in
                buttonHandler?(btnCancel)
            }))
            
            if let tinColor = tintColor { alertViewController.view.tintColor = tinColor }
            onPresentController.present(alertViewController, animated: true, completion: nil)
            return alertViewController
        }
        
        return nil
    }
}
