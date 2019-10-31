//
//  UIViewController.swift
//  JogTracker
//
//  Created by Prostor9 on 10/30/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String?, message: String?, buttonTitle: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: buttonTitle, style: .default) { _ in }
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
}
