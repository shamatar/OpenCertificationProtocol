//
//  RoundedButton.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 06/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderWidth
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 0.5294117647, green: 0.2784313725, blue: 0.9058823529, alpha: 1) {
        didSet {
            layer.borderColor = borderColor.cgColor
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.setNeedsDisplay()
        }
    }
}
