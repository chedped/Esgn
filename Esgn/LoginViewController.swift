//
//  LoginViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/2/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftyJSON
import FBSDKLoginKit

typealias LoginCompletion = (_ success: Bool) -> Void

class LoginViewController: MWZBaseViewController {

    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var loginCompletion: LoginCompletion? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        let tapGesture = UITapGestureRecognizer { (gesture, state, point) in
            self.view.endEditing(true)
        }
        self.view.addGestureRecognizer(tapGesture!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        
        super.keyboardWillShow(notification)
        
        let userinfo = notification.userInfo
        let kbSize: CGSize = ((userinfo as! [String:AnyObject])[UIKeyboardFrameEndUserInfoKey]?.cgRectValue.size)!
        
        let contentInsets = UIEdgeInsets(top: self.scrollView.contentInset.top, left: 0, bottom: kbSize.height, right: 0) as UIEdgeInsets
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame as CGRect
        aRect.size.height -= (kbSize.height)
        
        var origin = self.textPassword.superview!.frame.origin//self.view.convert(self.textThaiId.frame.origin, from: self.textThaiId.superview!)
        origin.y += self.textPassword.superview!.frame.size.height + 40//self.textThaiId.frame.size.height + 20
        
        
        if( !aRect.contains(origin)) {
            let scrollPoint = CGPoint(x: 0.0, y: origin.y-aRect.size.height)
            self.perform({ (sender) in
                self.scrollView.setContentOffset(scrollPoint, animated: true)
            }, afterDelay: 0.0)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        
        super.keyboardWillHide(notification)
        let contentInsets = UIEdgeInsets(top: self.scrollView.contentInset.top, left: 0, bottom: 0, right: 0) as UIEdgeInsets
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func onClose( _ sender: AnyObject ) {        
        
        dismiss(animated: true) { 
            if let completion = self.loginCompletion {
                completion(false)
            }
        }
    }
    
    @IBAction func onLogin( _ sender: AnyObject ) {
        
        self.view.endEditing(true)
        
        guard let username = textUsername.text, !username.isEmpty else {
            
            self.showAPIAlertWithMessage("Enter your ID")
            return
        }
        
        guard let password = textPassword.text, !password.isEmpty else {
            
            self.showAPIAlertWithMessage("Enter your password")
            return
        }
        
        ProgressHUD.show(self.navigationController!.view)
        
        API.login(withUserName: username,
                  password: password) { (json, error) in
                    
                    ProgressHUD.hiden(self.navigationController!.view, animated: true)
                    if error == nil {
                        
                        self.onLoginCompleted(json!)
                        //appDelegate().prepareHome()
                        
                    }
                    else {
                        self.showAPIAlertWithError(error)
                    }
        }
    }
    
    func onLoginCompleted( _ json: JSON ) {
        
        UserProfile.sharedInstance.parseObject(json["data"]["result"]["user"])
        UserProfile.sharedInstance.parseToken(json["data"]["result"])
        UserProfile.sharedInstance.saveData()
        
        WishlistData.shared.getWishlist(completion: nil)
        
        if let completion = self.loginCompletion {
            completion(true)
        }
        
        NotificationCenter.default.post(name: Notifications.login.name,
                                        object: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onLoginGoogle(_ sender: AnyObject) {
        
        ProgressHUD.show(self.navigationController!.view)
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onLoginFacebook( _ sender: AnyObject ) {
        ProgressHUD.show(self.navigationController!.view)
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onFBTokenUpdated(_:)), name: NSNotification.Name.FBSDKAccessTokenDidChange, object: nil)
        
        if FBSDKAccessToken.current() == nil {
            
            let login: FBSDKLoginManager = FBSDKLoginManager()
            login.loginBehavior = FBSDKLoginBehavior.browser
            login.logIn(withReadPermissions: ["public_profile","email"],
                        from: self) { (result, error) in
                            
                            if( error != nil ) {
                                print("Process error")
                                ProgressHUD.hiden(self.navigationController!.view, animated: true)
                            } else if (result?.isCancelled) == true {
                                print("Cancelled")
                                ProgressHUD.hiden(self.navigationController!.view, animated: true)
                            } else {
                                print("Logged in")
                                
                                self.loadFacebookProfile()
                            }
            }
        }
        else {
            loadFacebookProfile()
        }
    }
    
    func onFBTokenUpdated( _ notification: Notification ) {
        
        let info = notification.userInfo
        print(info ?? "info = nil")
    }
    
    func loadFacebookProfile() {
        
        FBSDKGraphRequest.init(graphPath: "me",
                               parameters: ["fields": "id,name,first_name,last_name,email"])
            .start { (connection, result, error) in
                
                ProgressHUD.hiden(self.navigationController!.view, animated: true)
                if error != nil {
                    self.showAPIAlertWithError(error as NSError?)
                }
                else {
                    let data:[String:Any] = result as! [String : Any]
                    
                    print(data["id"] ?? "id = nil")
                    print(data["name"] ?? "name = nil")
                    print(data["first_name"] ?? "first_name = nil")
                    print(data["last_name"] ?? "last_name = nil")
                    print(data["email"] ?? "email = nil")
                    
//                    let fbloginData: [String: Any] = ["login" : "facebook",
//                                                      "id" : data["id"]!,
//                                                      "name" : data["name"]!,
//                                                      "email" : data["email"] ?? ""
//                    ]
                    
                    self.loginWithFacebook(data["id"] as! String, fbToken: FBSDKAccessToken.current().tokenString!)
                }
        }
    }
    
    func loginWithFacebook( _ fbid: String, fbToken: String ) {
        
        ProgressHUD.show(self.navigationController!.view)
        API.login(withFacebook: fbid,
                  fbtoken: fbToken) { (json, error) in
                    
                    if error == nil {
                        self.onLoginCompleted(json!)
                    }
                    else {
                        self.showAPIAlertWithError(error)
                        FBSDKLoginManager().logOut()
                    }
        }
    }
}

extension LoginViewController: GIDSignInUIDelegate,GIDSignInDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        ProgressHUD.show(self.navigationController!.view)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        ProgressHUD.hiden(self.navigationController!.view, animated: true)
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print(userId ?? "userId = nil")
            print(idToken ?? "idToken = nil")
            print(fullName ?? "fullName = nil")
            print(givenName ?? "givenName = nil")
            print(familyName ?? "familyName = nil")
            print(email ?? "email = nil")
            
            let ggloginData: [String: Any] = ["login" : "google",
                                              "id" : userId!,
                                              "token" : idToken!,
                                              "name" : fullName!,
                                              "email" : email!
            ]
            
            self.loginWithGoogleToken(gToken: idToken)
            // ...
        } else {
            print("\(error.localizedDescription)")
            ProgressHUD.hiden(self.navigationController!.view, animated: true)
            self.showAPIAlertWithError(error as NSError?)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        
        //ProgressHUD.hiden(self.navigationController!.view, animated: true)
        //self.showAPIAlertWithError(error)
        
    }
    
    func loginWithGoogleToken( gToken: String! ) {
        
        ProgressHUD.show(self.navigationController!.view)
        
        API.login(withGoogleToken: gToken) { (json, error) in
            ProgressHUD.hiden(self.navigationController!.view, animated: true)
            if error == nil {
                self.onLoginCompleted(json!)
            }
            else {
                self.showAPIAlertWithError(error)
                GIDSignIn.sharedInstance().signOut()
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textUsername {
            
            if let text = textField.text, !text.isEmpty {
                
                textPassword.becomeFirstResponder()
                return true
            }
        }
        else if textField == textPassword {
            
            if let text = textField.text, !text.isEmpty {
                
                onLogin(UIButton())
                return true
            }
        }
        return false
    }
}
