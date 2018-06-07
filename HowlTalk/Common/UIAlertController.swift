//
//  UIAlertViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 07/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func showError(viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
