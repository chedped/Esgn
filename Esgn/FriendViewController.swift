//
//  FriendViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class FriendViewController: MWZBaseViewController {

    @IBOutlet weak var btnFriend: UIButton!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lineFriend: UIView!
    @IBOutlet weak var lineRequest: UIView!
    @IBOutlet weak var lineSearch: UIView!
    @IBOutlet weak var carousel: iCarousel!
    
    var viewcontrollers: [UIViewController] = []
    //var carousel: iCarousel!
    
    var tabButton: [UIButton]!
    var tabLine: [UIView]!
    var selectedTab: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Friends"
        
        tabButton = [btnFriend, btnRequest, btnSearch]
        tabLine = [lineFriend, lineRequest, lineSearch]
        
        updateTabUI(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onBack(_ sender: AnyObject) {
        
        NotificationCenter.default.removeObserver(viewcontrollers[1],
                                                  name: Notifications.UpdateChatroom.name,
                                                  object: nil)
        
        super.onBack(sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareFriendList()
        prepareFriendRequest()
        prepareFriendSearch()
        
        prepareView()
    }

    func updateTabUI( index: Int ) {
        
        for (i,btn) in tabButton.enumerated() {
            btn.isSelected = false
            tabLine[i].isHidden = true
        }
        
        tabButton[index].isSelected = true
        tabLine[index].isHidden = false
    }
    
    @IBAction func onTab( _ sender: AnyObject ) {
        
        let button = sender as! UIButton
        let tag = button.tag
        
        selectedTab = tag
        updateTabUI(index: tag)
        
        carousel.currentItemIndex = tag
    }

}

extension FriendViewController: iCarouselDelegate, iCarouselDataSource {
    
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
    
    func prepareFriendList() {
        
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "friendlistviewcontroller") as! FriendListViewController
        
        vc.list_type = .friend
        vc.navcontroller = self.navigationController
        vc.view.frame = carousel.bounds
        
        viewcontrollers.append(vc)
    }
    
    func prepareFriendRequest() {
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "chatroomviewcontroller") as! ChatroomViewController
        
        vc.view.frame = carousel.bounds
        vc.navcontroller = self.navigationController
        viewcontrollers.append(vc)
    }
    
    func prepareFriendSearch() {
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "searchfriendviewcontroller") as! SearchFriendViewController
        
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
