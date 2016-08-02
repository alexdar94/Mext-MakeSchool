//
//  UIViewController+DismissKeyboard.swift
//  Mext
//
//  Created by Alex Lee on 01/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}