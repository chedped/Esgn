//
//  AppDelegate.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 9/28/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SwiftyJSON
import Google.SignIn
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigation: UINavigationController?

    var canRotate: Bool! = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: " + (configureError?.localizedDescription)!)
        
        UserProfile.sharedInstance.loadData()
        
        ChatManager.shared
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication,
                     open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        
        if (url.scheme?.hasPrefix("fb")) == true {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        }
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    func prepareLogin( completion: LoginCompletion? ) {
        
        let vc = UIStoryboard(name:"Login",bundle: nil).instantiateViewController(withIdentifier: "loginnavigation") as! UINavigationController
        
        let loginVC = vc.topViewController as? LoginViewController
        loginVC?.loginCompletion = completion
        
        defaultNavigationBar(vc.navigationBar)
        transparentNavigationBar(vc.navigationBar)
        
        //self.window?.rootViewController = vc
        //self.window?.makeKeyAndVisible()
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func prepareHome() {
        
        //let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "maintabcontroller") as! UITabBarController
        
        let vc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "mainnavcontroller") as! UINavigationController
        
        let leftvc = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "leftmenuviecontroller") as! LeftMenuViewController
        /*
        if vc.viewControllers != nil {
            for vc in vc.viewControllers! {
                
                if let navvc = vc as? UINavigationController {
                    defaultNavigationBar(navvc.navigationBar)
                }
            }
        }
 
        vc.tabBar.barTintColor = calculateColorFromDesignToNavigationBar(withColor: MColor.Hex("#212221"))
        */
        
        mainNavigation = vc
        defaultNavigationBar(vc.navigationBar)
        SlideMenuOptions.leftViewWidth = appDelegate().window!.bounds.size.width * 0.70
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.hideStatusBar = false
        
        let slidingVC = SlideMenuController(mainViewController: vc, leftMenuViewController: leftvc)
        
        slidingVC.automaticallyAdjustsScrollViewInsets = true
        
        self.window?.rootViewController = slidingVC
        self.window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.canRotate == true {
            return UIInterfaceOrientationMask.all
        }
        
        return UIInterfaceOrientationMask.portrait
    }
}

func defaultNavigationBar( _ navigationBar: UINavigationBar ) {
    
    navigationBar.barTintColor = calculateColorFromDesignToNavigationBar(withColor: MColor.Hex("#212221"))
    navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                         NSFontAttributeName: DefaultFontLight(18)]
    navigationBar.isTranslucent = true
}

func transparentNavigationBar( _ navigationBar: UINavigationBar ) {
    navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
}

func appDelegate () -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func calculateColorFromDesignToNavigationBar( withColor color: UIColor ) -> UIColor {
    
    func colorFormula( n: CGFloat ) -> CGFloat {
        let value = ((n*255)-40) / (1-40/255)
        if value < 0 {
            return 0
        }
        return value
    }
    
    let newRed = colorFormula(n: color.redValue)
    let newGreen = colorFormula(n: color.greenValue)
    let newBlue = colorFormula(n: color.blueValue)
    
    return UIColor(red: newRed/255, green: newGreen/255, blue: newBlue/255, alpha: color.alphaValue)
}

func isJailbroken() -> Bool {
    
    #if (arch(i386) || arch(x86_64)) && os(iOS)
        return false
    #else
        // Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath: "/etc/apt")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
            || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) {
            return true
        }
        
        // Check 2 : Reading and writing in system directories (sandbox violation)
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            //Device is jailbroken
            return true
        }
        catch {
            return false
        }
    #endif
}

func exitOnJailbreak() {
    if isJailbroken() == true {
        // Exit the app if Jailbroken
        
        let alert = UIAlertController(withStyle: .alert,
                                      title: "Warning",
                                      message: "Jail broken device is not allow.",
                                      cancelTitle: "Ok",
                                      handler: { (alert) in
                                        
                                        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                                        let label: UILabel? = nil
                                        label!.text = ""
                                        
        })
        
        appDelegate().window!.perform({ (sender) in
            appDelegate().window!.rootViewController!.present(alert, animated: true, completion: nil)
        }, afterDelay: 0.1)
        
    }
}

func DefaultFont( _ size: CGFloat ) -> UIFont! {
    
    var asize = size
    if UIDevice.isScreen35inch() == true ||
        UIDevice.isScreen4inch() == true {
        asize = ceil(size * 0.75)
    }
    return UIFont(name: "Kanit-Regular", size: asize)
}

func DefaultFontBold( _ size: CGFloat ) -> UIFont! {
    
    var asize = size
    if UIDevice.isScreen35inch() == true ||
        UIDevice.isScreen4inch() == true {
        asize = ceil(size * 0.75)
    }
    return UIFont(name: "Kanit-Bold", size: asize)
}

func DefaultFontMedium( _ size: CGFloat) -> UIFont! {
    
    var asize = size
    if UIDevice.isScreen35inch() == true ||
        UIDevice.isScreen4inch() == true {
        asize = ceil(size * 0.75)
    }
    return UIFont(name: "Kanit-Medium", size: asize)
}

func DefaultFontLight( _ size: CGFloat) -> UIFont! {
    
    var asize = size
    if UIDevice.isScreen35inch() == true ||
        UIDevice.isScreen4inch() == true {
        asize = ceil(size * 0.75)
    }
    return UIFont(name: "Kanit-Light", size: asize)
}

func DefaultTextFieldFont() -> UIFont! {
    var asize:CGFloat = 16
    if UIDevice.isScreen35inch() == true ||
        UIDevice.isScreen4inch() == true {
        asize = 16
    }
    return UIFont(name: "Kanit-Regular", size: asize)
}

func DefaultButtonFont() -> UIFont! {
    return DefaultFontMedium(16)
}


