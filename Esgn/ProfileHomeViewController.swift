//
//  ProfileHomeViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/2/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileHomeViewController: MWZBaseViewController {

    @IBOutlet weak var labelTeamName: UILabel!
    @IBOutlet weak var labelTeamRank: UILabel!
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var labelPlayed: UILabel!
    @IBOutlet weak var labelWin: UILabel!
    @IBOutlet weak var labelDraw: UILabel!
    @IBOutlet weak var labelLose: UILabel!
    @IBOutlet weak var lcTeamHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTeam: UIView!
    
    @IBOutlet weak var labelWallet: UILabel!
    @IBOutlet weak var labelDiamond: UILabel!
    @IBOutlet weak var labelGold: UILabel!
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var labelMembership: UILabel!
    @IBOutlet weak var imgMembership: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: ProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isHidden = true
        
        getProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfile() {
        
        API.getProfile(withUserId: UserProfile.sharedInstance.user_id) { (json, error) in
            
            if error == nil {
                self.onFinishLoadingProfile(json: json! )
            }
        }
    }

    func onFinishLoadingProfile( json: JSON! ) {
        
        UserProfile.sharedInstance.parseObject(json["data"]["result"])
        UserProfile.sharedInstance.saveData()
        
        if let delegate = self.delegate {
            delegate.profileDidUpdateProfile()
        }
        
        //z debug
        lcTeamHeight.constant = 0
        viewTeam.isHidden = true
        
        scrollView.isHidden = false
        loadingView.stopAnimating()
        updateProfile()
    }
    
    func updateProfile() {
        
        let profile = UserProfile.sharedInstance
        
        labelWallet.text = profile.wallet.toDecimalString
        labelGold.text = profile.gold.toDecimalString
        labelDiamond.text = profile.diamond.toDecimalString
        labelLevel.text = String(profile.level)
        
        if let class_name = profile.member_class_name, !class_name.isEmpty {
            labelMembership.text = class_name
            let memberimgname = "icn_member_" + profile.member_class_id!
            imgMembership.image = UIImage(named: memberimgname)
        }
        else {
            imgMembership.image = nil
            labelMembership.text = "-"
        }
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
