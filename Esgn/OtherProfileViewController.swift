//
//  OtherProfileViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 1/5/18.
//  Copyright © 2018 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class OtherProfileViewController: MWZBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelFriends: UILabel!
    @IBOutlet weak var labelVideo: UILabel!
    @IBOutlet weak var labelFollower: UILabel!
    @IBOutlet weak var labelSubsriber: UILabel!
    
    @IBOutlet weak var labelTeamName: UILabel!
    @IBOutlet weak var labelTeamRank: UILabel!
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var labelPlayed: UILabel!
    @IBOutlet weak var labelWin: UILabel!
    @IBOutlet weak var labelDraw: UILabel!
    @IBOutlet weak var labelLose: UILabel!
    @IBOutlet weak var lcTeamHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTeam: UIView!
    
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var labelMembership: UILabel!
    @IBOutlet weak var imgMembership: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var user_id: String!
    var user_full_name: String!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = user_full_name
        
        getFriendProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFriendProfile() {
        
        API.getProfile(withUserId: user_id) { (json, error) in
            
            if error == nil {
                self.onFinishLoadingProfile(json: json! )
            }
        }
    }
    
    func onFinishLoadingProfile( json: JSON! ) {
        
        user = User(withJSON: json["data"]["result"])
        
        //z debug
        lcTeamHeight.constant = 0
        viewTeam.isHidden = true
        
        scrollView.isHidden = false
        loadingView.stopAnimating()
        updateProfile()
    }
    
    func updateProfile() {
        
        guard let profile = user else {
            return
        }
        
        labelName.text = profile.fullname
        labelNickname.text = profile.nickname
        labelVideo.text = String(profile.video)
        labelFollower.text = String(profile.followers)
        labelSubsriber.text = String(profile.subscriber)
        labelFriends.text = String(profile.friend_count)
        
        if let imgURL = profile.picture, !imgURL.isEmpty {
            imgProfile.sd_setImage(with: URL(string: imgURL))
        }
        else {
            imgProfile.image = UIImage(named: "img_friend_2")
        }
        
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
