//
//  ProgressHUD.swift
//  iOTalkEGG
//
//  Created by Appsynth on 5/21/2558 BE.
//  Copyright (c) 2558 Appsynth. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProgressHUD: NSObject, MBProgressHUDDelegate {
    
    class func show(_ view: UIView) {
        
        if view.viewWithTag(9999999) != nil {
            return
        }
        
        let HUD: MBProgressHUD = MBProgressHUD(view: view)
        HUD.tag = 9999999
        //HUD.dimBackground = true
        HUD.backgroundView.color = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        //HUD.backgroundView.style = MBProgressHUDBackgroundStyle.Blur
        view.addSubview(HUD)
        HUD.show(animated: true)
    }
    
    class func showWithMessage(_ view: UIView, message: String) {
        let HUD: MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.label.text = message
    }
    
    class func showWithMessage(_ view: UIView, message: String, closeAfter delay: Double) {
        let HUD: MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.label.text = message
        
        let delayTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.hiden(view, animated: true)
        }
    }
    
    class func showSuccess(_ view: UIView, message: String?) {
        self.showHUDWithIcon("Checkmark", message: message, view: view)
    }
    
    class func showError(_ view: UIView, message: String?) {
        self.showHUDWithIcon("like_active", message: message, view: view)
    }
    
    class func showHUDWithIcon(_ iconName: String, message: String?, view: UIView) {
        let HUD: MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.mode = .customView
        HUD.customView = UIImageView(image: UIImage(named: iconName))
        
        if let msg = message {
            HUD.label.text = msg
        }
        
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.hiden(view, animated: true)
        }
    }
    
    class func hiden(_ view: UIView, animated: Bool) {
        //MBProgressHUD.hideAllHUDsForView(view, animated: animated)
        MBProgressHUD.hide(for: view, animated: animated)
    }
}
