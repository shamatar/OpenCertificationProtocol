//
//  CommonExtensions.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 29.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func hexToUInt<T>() -> T? where T: FixedWidthInteger {
        var value = self
        if value.hasPrefix("0x") {
            value.removeFirst(2)
        }
        return T(value, radix: 16)
    }
}
