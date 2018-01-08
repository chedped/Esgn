//
//  Borderable.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 9/28/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//


import UIKit

protocol Borderable {
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
}

@IBDesignable
extension UIView: Borderable {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        
        set {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
