//
//  UIAlertController.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 4/19/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init( withStyle style: UIAlertControllerStyle, title: String?, message: String?, cancelTitle: String?, handler: ((UIAlertAction) -> Swift.Void)? = nil ) {
        
        self.init(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: cancelTitle, style: .cancel, handler: handler)
        self.addAction(action)
    }
    
    func addAction( title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Swift.Void)? = nil ) {
        
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    
}
