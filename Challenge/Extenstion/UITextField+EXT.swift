//
//  UITextField+EXT.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation
import UIKit

private var __maxLengths = [UITextField: Int]()

extension UITextField {
        
        @IBInspectable var placeHolderColor: UIColor? {
            get {
                return self.placeHolderColor
            }
            set {
                self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
            }
        }
        
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 500
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = String((t!.prefix(maxLength)))
    }
    
}
