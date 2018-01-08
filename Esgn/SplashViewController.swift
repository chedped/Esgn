//
//  SplashViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 9/28/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class SplashViewController: MWZBaseViewController {

    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var labelErrorText: UILabel!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var isTutorial: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.isScreen35inch() {
            self.imgBG.image = UIImage(named: "Splash_i4")
        }
        
        labelErrorText.preferredMaxLayoutWidth = appDelegate().window!.bounds.size.width - 40
        labelErrorText.text = ""
        
        labelVersion.text = "Version " + Utility.appVersion() + "." + Utility.buildVersion()
        
        if let _ = UserDefaults.standard.object(forKey: "tutorial") {
            isTutorial = false
        }
        
        self.perform({ (sender) in
            self.onFinishLoadingData()
        }, afterDelay: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTutorial() {
        
        API.getTutorial { (json, error) in
            
            if error == nil {
                
                let tutorialdata = json!["data"]["tutorials"].arrayValue
                var tutorials: [Tutorial] = []
                for tutorialjson in tutorialdata {
                    let tutor = Tutorial(withJSON: tutorialjson)
                    tutorials.append(tutor)
                }
                self.presentTutorial( withTutorial: tutorials)
            }
            else {
                appDelegate().prepareHome()
            }
        }
    }
    
    func onFinishLoadingData() {
    
        if UserProfile.sharedInstance.isLogin() == true {
            loginToken()
        }
        else {
            getStart()
        }
    }
    
    func loginToken() {
        
        API.login(withToken: UserProfile.sharedInstance.token!) { (json, error) in
            
            if error == nil {
                
                print(json!)
                UserProfile.sharedInstance.parseObject(json!["data"]["result"]["user"])
                UserProfile.sharedInstance.parseToken(json!["data"]["result"])
                UserProfile.sharedInstance.saveData()
                
                WishlistData.shared.getWishlist(completion: nil)
                
                self.getStart()
            }
            else {
                //z debug
                print(error)
                UserProfile.sharedInstance.logout()
                self.getStart()
            }
        }
    }
    
    func getStart() {
        if isTutorial == true {
            getTutorial()
        }
        else {
            appDelegate().prepareHome()            
        }
    }
    
    func presentTutorial( withTutorial tutorials: [Tutorial] ) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialviewcontroller") as! TutorialViewController
        vc.completion = {
            self.isTutorial = false
            self.getStart()
        }
        vc.tutorials = tutorials
        self.present(vc, animated: true, completion: nil)        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
