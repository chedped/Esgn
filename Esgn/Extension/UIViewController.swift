//
//  UIViewController.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 3/22/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setMenuBarButtonItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "img_header_logo")!)
        //self.navigationItem.leftBarButtonItem?.tintColor = MColor.getColorCode("theme_main")
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        
        if let panGesture = self.slideMenuController()?.leftPanGesture {
            self.slideMenuController()?.view.removeGestureRecognizer(panGesture)
        }
        
        
        //self.slideMenuController()?.addRightGestures()
    }
    
    func removeMenuBarButtonItem() {
        self.navigationItem.leftBarButtonItem = nil
        //self.navigationItem.rightBarButtonItem = nil
        //self.slideMenuController()?.removeLeftGestures()
        //self.slideMenuController()?.removeRightGestures()
    }
}
