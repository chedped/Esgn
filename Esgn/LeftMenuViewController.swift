//
//  LeftMenuViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 9/28/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

enum Menu: Int {
    case live, market, community, inventory, notification, num
}

class LeftMenuViewController: MWZBaseViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelNickName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var viewNotLogin: UIView!
    @IBOutlet weak var viewLoggedIn: UIView!
    
    var selectedMenu: Int = 0
    
    var menuTitleLocalizedKey: [String] = ["Live!",
                                           "Market",
                                           "Community",
                                           "Inventory",
                                           "Notification",
    ]
    
    var menuImageName: [String] = ["icn_slidemenu_live",
                                   "icn_slidemenu_market",
                                   "icn_slidemenu_community",
                                   "icn_slidemenu_inventory",
                                   "icn_slidemenu_inventory"
                                   ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 60
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        updateProfile()
    }
    
    func updateUI() {
        viewLoggedIn.isHidden = !UserProfile.sharedInstance.isLogin()
        viewNotLogin.isHidden = !viewLoggedIn.isHidden
        
        menuTitleLocalizedKey = ["Live!",
                                 "Market",
                                 "Community",
                                 "Inventory",
                                 "Notification",
        ]
        
        menuImageName = ["icn_slidemenu_live",
                         "icn_slidemenu_market",
                         "icn_slidemenu_community",
                         "icn_slidemenu_inventory",
                         "icn_slidemenu_notification"]
        
        if UserProfile.sharedInstance.isLogin() == true {
            
            btnLogout.setTitle("Logout", for: .normal)
            btnLogout.backgroundColor = MColor.getColorCode("theme_red")
        }
        else {
            
            btnLogout.setTitle("Login", for: .normal)
            btnLogout.backgroundColor = MColor.getColorCode("theme_blue")
        }
        
        tableView.reloadData()
    }
    
    func updateProfile() {
        
        if UserProfile.sharedInstance.isLogin() == true {
            labelName.text = UserProfile.sharedInstance.fullname
            labelNickName.text = UserProfile.sharedInstance.nickname
            
            if let imgURL = UserProfile.sharedInstance.picture, !imgURL.isEmpty {
                imgProfile.sd_setImage(with: URL(string: imgURL))
            }
            else {
                imgProfile.image = UIImage(named: "img_friend_2")
            }
        }
    }
    
    @IBAction func onLogin( _ sender: AnyObject ) {
        
        if UserProfile.sharedInstance.isLogin() == true {
            
            let alert = UIAlertController(withStyle: .alert,
                                          title: nil,
                                          message: "Do you want to Logout?",
                                          cancelTitle: "Cancel")
            let action = UIAlertAction(title: "Logout",
                                       style: .default,
                                       handler: { (action) in
                                        
                                        ProgressHUD.show(self.view)
                                        
                                        API.logout(withToken: UserProfile.sharedInstance.token!,
                                                   completion: { (json, error) in
                                                    
                                                    ProgressHUD.hiden(self.view, animated: true)
                                                    if error == nil {
                                                        
                                                        UserProfile.sharedInstance.logout()
                                                        
                                                        NotificationCenter.default.post(name: Notifications.logout.name,
                                                                                        object: nil)
                                                        
                                                        self.updateUI()
                                                        self.updateProfile()
                                                        //appDelegate().prepareLogin(completion: nil)
                                                    }
                                                    else {
                                                        self.showAPIAlertWithError(error)
                                                    }
                                        })
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else {
            appDelegate().prepareLogin(completion: { (success) in
                
                if success == true {
                    self.updateProfile()
                }
            })
        }
    }

}

extension LeftMenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitleLocalizedKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftmenucell", for: indexPath) as! LeftMenuCell
        
        cell.labelMenu.text = menuTitleLocalizedKey[indexPath.row]
        cell.imgICon.image = UIImage(named: menuImageName[indexPath.row])
        
        cell.viewBadge.isHidden = true
        
        if indexPath.row == selectedMenu {
            cell.backgroundColor = MColor.getColorCode("theme_red")
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu: Menu = Menu(rawValue: indexPath.row)!
        switch menu {
            
        case .live  :
            
            if let navvc = self.slideMenuController()?.mainViewController as? UINavigationController {
                navvc.popToRootViewController(animated: true)
            }
            self.slideMenuController()?.closeLeft()
            
            break
            
        case .market :
            if UserProfile.sharedInstance.isLogin() == false {
                
                appDelegate().prepareLogin(completion: { (success) in
                    if success == true {
                        self.prepareMarket()
                    }
                })
            }
            else {
                prepareMarket()
            }
            break
            
        case .community :
            
            if UserProfile.sharedInstance.isLogin() == false {
                
                appDelegate().prepareLogin(completion: { (success) in
                    if success == true {
                        self.prepareCommunity()
                    }
                })
            }
            else {
                prepareCommunity()
            }
            
            break
            
            
        case .inventory :
            if UserProfile.sharedInstance.isLogin() == false {
                
                appDelegate().prepareLogin(completion: { (success) in
                    if success == true {
                        self.prepareInventory()
                    }
                })
            }
            else {
                prepareInventory()
            }
            break
            
        case .notification :
            break
            
        case .num :
            break
        }
    }
    
    func prepareCommunity() {
        
        //if let tabVC = self.slideMenuController()?.mainViewController as? UITabBarController {
            
            //if let navvc = tabVC.selectedViewController as? UINavigationController {
            if let navvc = self.slideMenuController()?.mainViewController as? UINavigationController {
                let vc = UIStoryboard(name:"View",bundle: nil).instantiateViewController(withIdentifier: "friendviewcontroller") as! FriendViewController
                
                navvc.pushViewController(vc, animated: true)
                self.slideMenuController()?.closeLeft()
            }
        //}
    }
    
    func prepareMarket() {
        //if let tabVC = self.slideMenuController()?.mainViewController as? UITabBarController {
            
            //if let navvc = tabVC.selectedViewController as? UINavigationController {
            if let navvc = self.slideMenuController()?.mainViewController as? UINavigationController {
                let vc = UIStoryboard(name:"View",bundle: nil).instantiateViewController(withIdentifier: "marketviewcontroller") as! MarketViewController
                
                navvc.pushViewController(vc, animated: true)
                self.slideMenuController()?.closeLeft()
            }
        //}
    }
    
    func prepareInventory() {
        if let navvc = self.slideMenuController()?.mainViewController as? UINavigationController {
            let vc = UIStoryboard(name:"View",bundle: nil).instantiateViewController(withIdentifier: "inventoryviewcontroller") as! InventoryViewController
            
            navvc.pushViewController(vc, animated: true)
            self.slideMenuController()?.closeLeft()
        }
    }
    
    @IBAction func prepareProfile() {
        
        //if let tabVC = self.slideMenuController()?.mainViewController as? UITabBarController {
            //if let navvc = tabVC.selectedViewController as? UINavigationController {
            if let navvc = self.slideMenuController()?.mainViewController as? UINavigationController {
                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "profileviewcontroller") as! ProfileViewController
                
                vc.hidesBottomBarWhenPushed = true
                navvc.pushViewController(vc, animated: true)
                self.slideMenuController()?.closeLeft()
            }
            
        //}
        
    }
}
