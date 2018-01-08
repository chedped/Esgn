//
//  ASBaseViewController.swift
//  iOTalkEGG
//
//  Created by Appsynth on 5/17/2558 BE.
//  Copyright (c) 2558 Appsynth. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MWZBaseViewController: UIViewController {

    typealias CallBack = (_ sender: AnyObject?) -> ()
    
    var keyboardFrame:CGRect!
    var keyboardDuration:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addForNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeForNotificationCenter()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        SDImageCache.shared().clearMemory()
    }
    
    //MARK: - NotificationCenter
    func addForNotificationCenter() {
        //===== Keyboard =====//
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MWZBaseViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MWZBaseViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeForNotificationCenter() {
        //===== Keyboard =====//
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            keyboardFrame       = ((userInfo as! [String:AnyObject])[UIKeyboardFrameBeginUserInfoKey])?.cgRectValue
            keyboardDuration    = ((userInfo as! [String:AnyObject])[UIKeyboardAnimationDurationUserInfoKey] as! Double)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            keyboardFrame       = ((userInfo as! [String:AnyObject])[UIKeyboardFrameBeginUserInfoKey])?.cgRectValue
            keyboardDuration    = ((userInfo as! [String:AnyObject])[UIKeyboardAnimationDurationUserInfoKey] as! Double)
        }
    }
    
    //MARK: - AlertView
    func showAPIAlertWithError( _ error: Error! ) {
        
        if let error: NSError = error as NSError? {
            let message = error.localizedDescription
            let cancelTitle = Localized.forKey("ok")
            
            let alert = UIAlertController(withStyle: .alert, title: nil, message: message, cancelTitle: cancelTitle)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAPIAlertWithError( _ error: Error!, completion: (()->Void)? ) {
        
        if let error: NSError = error as NSError? {
            let message = error.localizedDescription
            let cancelTitle = Localized.forKey("ok")
            
            let alert = UIAlertController(withStyle: .alert, title: nil, message: message, cancelTitle: cancelTitle, handler: { (action) in
                completion?()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAPIAlertWithMessage( _ message: String? ) {
        
        guard let _ = message else {
            return
        }
        
        let cancelTitle = Localized.forKey("ok")
        
        let alert = UIAlertController(withStyle: .alert, title: nil, message: message!, cancelTitle: cancelTitle)
        self.present(alert, animated: true, completion: nil)    
    }
    
    func showAPIAlertWithMessage( _ message: String?, completion: (()->Void)? ) {
        
        guard let _ = message else {
            return
        }
        
        let cancelTitle = Localized.forKey("ok")
        
        let alert = UIAlertController(withStyle: .alert, title: nil, message: message, cancelTitle: cancelTitle, handler: { (action) in
            completion?()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func gradientBG() {
        
        self.view.backgroundColor = UIColor.clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let color1 = MColor.Hex("#FFFFFF")
        let color2 = MColor.Hex("#F4F4F4")
        let color3 = MColor.Hex("#D7D7D7")
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradientLayer.locations = [0.0, 0.3333,0.666666]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /*
    func alertErrorTechnical() {
        let message = Language.myStringForKey("error_default")
        let alert = self.alert(message: message)
        
        alert.setCancelButtonWithTitle(Language.myStringForKey("ok"), handler: nil)
        alert.show()
    }
    */
    /*
    func showAlertViewWithTitle(title: String, message: String, cancelTitle: String, othertitle: String?, tag: Int, delegate: UIAlertViewDelegate?) {
        
        var alert: UIAlertView
        if (othertitle != nil && othertitle != "") {
            alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelTitle, otherButtonTitles: othertitle!)
        }
        else {
            alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelTitle)
        }
        
        alert.tag = tag
        alert.show()
    }
    */
    
    /*
    //MARK: - AlertErrorMessage
    func alertServerError(error: NSError?) {
        
        if (error != nil) {
            if let dict = error!.userInfo as? [String:AnyObject]  {
                if let message = dict["message"] as? String {
                    let alert = self.alert(message: message)
                    
                    alert.setCancelButtonWithTitle(Language.myStringForKey("ok"), handler: nil)
                    alert.show()
                    
                    return
                }
            }
        }
        
        self.alertErrorTechnical()
    }
    */
    
    /*
    //MARK: - ActionSheet
    func actionSheet(title: String? = "") -> UIActionSheet {
        let actionSheet = UIActionSheet(title: title)
        
        return actionSheet
    }
    */
    
    /*
    //MARK: - Other Action
    func addButtonBackWithTitle(title: String? = Language.myStringForKey("cancel"), handler: CallBack) {
        
        if self.navigationItem.leftBarButtonItem != nil {
            if let btn = self.navigationItem.leftBarButtonItem?.customView as? ASButtonCustom {
                
                btn.setTitle(title, forState: UIControlState.Normal)
                btn.sizeToFit()
                btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                
                return;
            }
        }
        
        let btn:ASButtonCustom = ASButtonCustom(frame: CGRectMake(0, 0, CGFloat.max, 30))
        btn.titleLabel?.font = UIFont(name: "True Light", size: 24)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.addEventHandler(handler, forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTitleColor(ASImage(named: "color_text_button_nav").getPixelColor(), forState: .Normal)
        
        btn.sizeToFit()
        
        let barItem = UIBarButtonItem(customView: btn)
        
        self.navigationItem.leftBarButtonItem = barItem
    }
    */
    /*
    func addButtonRightWithTitle(title: String? = Language.myStringForKey("ok"), enabled: Bool! = true, handler: CallBack) {
        
        if self.navigationItem.rightBarButtonItem != nil {
            if let btn = self.navigationItem.rightBarButtonItem?.customView as? ASButtonCustom {
                
                btn.alpha   = (enabled == true) ? 1.0 : 0.3
                btn.enabled = enabled
                
                btn.setTitle(title, forState: UIControlState.Normal)
                btn.sizeToFit()
                
                return;
            }
        }
        
        let btn:ASButtonCustom = ASButtonCustom(frame: CGRectMake(0, 0, CGFloat.max, 30))
        let barItem = UIBarButtonItem(customView: btn)
        
        btn.titleLabel?.font = UIFont(name: "True Light", size: 24)
        
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.addEventHandler(handler, forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setTitleColor(ASImage(named: "color_text_button_nav").getPixelColor(), forState: .Normal)
        
        btn.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = barItem
        
        btn.alpha               = (enabled == true) ? 1.0 : 0.3
        btn.enabled             = enabled
    }
    */
    
    @IBAction func onBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    //MARK: - Change root view controller
    func changeRootViewControllerWithViewController(newVC: UIViewController, animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if (appDelegate == nil) {
            return ;
        }
        
        let window = appDelegate!.window
        if (window == nil) {
            return ;
        }
        
        let oldVC = window!.rootViewController
        if (oldVC == nil) {
            return ;
        }
        
        window!.rootViewController = newVC
        
        if animated {
            window!.addSubview(oldVC!.view)
            window!.rootViewController!.view.alpha = 0.0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                window!.rootViewController!.view.alpha = 1.0
                oldVC!.view.alpha = 0.0
            }) { (finished: Bool) -> Void in
                oldVC!.view.removeFromSuperview()
            }
        }
    }
    
    func changeRootViewControllerByMainStoryboardWithId(storyboardId: String, animated: Bool) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier(storyboardId)
        if (vc.isEqual(nil)) {
            return ;
        }
        
        changeRootViewControllerWithViewController(vc, animated: animated)
    }
    
    func changeRootViewControllerByStoryboardName(storyboardName: String, storyboardId: String, animated: Bool) {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(storyboardId)
        if (vc.isEqual(nil)) {
            return ;
        }
        
        changeRootViewControllerWithViewController(vc, animated: animated)
    }
    
    func openLoginVC() {
        changeRootViewControllerByStoryboardName("Storyboard", storyboardId: "ASLoginViewController", animated: true)
    }
    
    func openLoginVcInCaseTokenHasExpired(alertMessage: String? = nil) {
        if EGSession.defaultSession().accessToken != nil {
            EGSession.defaultSession().accessToken = nil
            self.showAlertViewWithTitle("", message: alertMessage != nil ? alertMessage! : Language.myStringForKey("error_unauthorized"), cancelTitle: Language.myStringForKey("ok"), othertitle: nil, tag: 0, delegate: nil)
            self.openLoginVC()
        }
    }
    
    // MARK: - Device Orientation
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    //MARK: - PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.view.endEditing(true)
    }
*/
}
