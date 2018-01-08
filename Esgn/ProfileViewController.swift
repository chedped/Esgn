//
//  ProfileViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/2/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ProfileDelegate: NSObjectProtocol {
    
    func profileDidUpdateProfile()
    func profileDidUpdateFriendList( numOfFriends: Int! )    
}

class ProfileViewController: MWZBaseViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelFriends: UILabel!
    @IBOutlet weak var labelVideo: UILabel!
    @IBOutlet weak var labelCredit: UILabel!
    @IBOutlet weak var labelSubsriber: UILabel!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnFriends: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    
    @IBOutlet weak var lineHome: UIView!
    @IBOutlet weak var lineFriends: UIView!
    @IBOutlet weak var lineWishlist: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var loadingViewFriendNum: UIActivityIndicatorView!
    
    @IBOutlet weak var lcTopBarButtonWidth: NSLayoutConstraint!
    
    
    var viewcontrollers: [UIViewController] = []
    //var carousel: iCarousel!
    
    var tabButton: [UIButton]!
    var tabLine: [UIView]!
    var selectedTab: Int = 0
    var selectedTemp: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "My Profile"
        
        labelFriends.text = ""
        
        //tabButton = [btnHome, btnFriends, btnMembership, btnReward, btnWishlist, btnTournament]
        //tabLine = [lineHome, lineFriends, lineMembership, lineReward, lineWishlist, lineTournament]
        tabButton = [btnHome, btnFriends, btnWishlist]
        tabLine = [lineHome, lineFriends, lineWishlist]
        
        let width = appDelegate().window!.bounds.size.width
        //lcTopBarButtonWidth.constant = (width / 5.0) * 6.0
        
        imgProfile.circleView()
        
        updateTabUI(index: 0)
        updateProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareHome()
        prepareFriend()
        //prepareMembership()
        //prepareReward()
        prepareWishlist()
        //prepareTournament()
        
        prepareView()
    }
    
    func updateProfile() {
        
        let profile = UserProfile.sharedInstance
        labelName.text = profile.fullname
        labelNickname.text = profile.nickname
        labelVideo.text = String(profile.video)
        labelCredit.text = String(profile.followers)
        labelSubsriber.text = String(profile.subscriber)
        
        if let imgURL = profile.picture, !imgURL.isEmpty {
            imgProfile.sd_setImage(with: URL(string: imgURL))
        }
        else {
            imgProfile.image = UIImage(named: "img_friend_2")
        }
    }

    func updateTabUI( index: Int ) {
        
        for (i,btn) in tabButton.enumerated() {
            btn.isSelected = false
            tabLine[i].isHidden = true
        }
        
        tabButton[index].isSelected = true
        tabLine[index].isHidden = false
        
//        let width = btnHome.frame.size.width
//
//        if selectedTab > selectedTemp {
//            scrollView.setContentOffset(CGPoint(x: width,y:0), animated: true)
//        }
//        else if selectedTab < selectedTemp {
//            scrollView.setContentOffset(CGPoint(x: 0,y:0), animated: true)
//        }
//
//        selectedTemp = index
    }
    
    @IBAction func onTab( _ sender: AnyObject ) {
        
        let button = sender as! UIButton
        let tag = button.tag
        
        selectedTab = tag
        updateTabUI(index: tag)
        
        carousel.currentItemIndex = tag
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

extension ProfileViewController: iCarouselDelegate, iCarouselDataSource {
    
    func prepareView() {
        
        self.carousel!.delegate = self
        self.carousel!.dataSource = self
        self.carousel!.type = iCarouselType.linear
        self.carousel!.isPagingEnabled = true
        self.carousel!.isVertical = false
        self.carousel!.backgroundColor = MColor.Hex("#212221")
        self.carousel!.bounceDistance = 0.2
        self.carousel!.clipsToBounds = true
    }
    
    func prepareHome() {
        
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "profilehomeviewcontroller") as! ProfileHomeViewController
        
        vc.view.frame = carousel.bounds
        
        vc.delegate = self
        
        viewcontrollers.append(vc)
    }
    
    func prepareFriend() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "profilefriendsviewcontroller") as! ProfileFriendsViewController
        
        vc.view.frame = carousel.bounds
        vc.delegate = self
        vc.navController = self.navigationController
        
        viewcontrollers.append(vc)
    }
    
    func prepareMembership() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "profilemembershipviewcontroller") as! ProfileMembershipViewController
        
        vc.view.frame = carousel.bounds
        
        viewcontrollers.append(vc)
    }
    
    func prepareReward() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "profilemembershipviewcontroller") as! ProfileMembershipViewController
        
        vc.view.frame = carousel.bounds
        
        viewcontrollers.append(vc)
    }
    
    func prepareWishlist() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "wishlistviewcontroller") as! WishlistViewController
        
        vc.view.frame = carousel.bounds
        
        viewcontrollers.append(vc)
    }
    
    func prepareTournament() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "profilemembershipviewcontroller") as! ProfileMembershipViewController
        
        vc.view.frame = carousel.bounds
        
        viewcontrollers.append(vc)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewcontrollers.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let presentview = viewcontrollers[index].view
        presentview?.frame = carousel.bounds
        return viewcontrollers[index].view
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        let currentIndex: Int = carousel.currentItemIndex
        
        self.selectedTab = currentIndex
        updateTabUI(index: currentIndex)
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
        case .spacing:
            
            return value * 1.0
            
        case .wrap:
            return 0.0
            
        default:
            return value
        }
    }
}

extension ProfileViewController: ProfileDelegate {
    
    func profileDidUpdateProfile() {
        
        updateProfile()        
    }
    
    func profileDidUpdateFriendList(numOfFriends: Int!) {
        
        labelFriends.text = String(numOfFriends)
        loadingViewFriendNum.stopAnimating()
    }
}
