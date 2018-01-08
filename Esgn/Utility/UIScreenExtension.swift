//
//  UIScreenExtension.swift
//  EasyBuy
//
//  Created by Somsak Wongsinsakul on 10/25/16.
//  Copyright © 2016 Maya Wizard. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


extension UIScreen {
    public func isRetina() -> Bool {
        return screenScale() >= 2.0
    }
    
    public func isRetinaHD() -> Bool {
        return screenScale() >= 3.0
    }
    
    fileprivate func screenScale() -> CGFloat? {
        if UIScreen.main.responds(to: Selector("scale")) {
            return UIScreen.main.scale
        }
        return nil
    }
}
