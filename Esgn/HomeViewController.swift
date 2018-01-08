//
//  ViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 9/28/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON
import XCDYouTubeKit

class HomeViewController: MWZBaseViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var live: Live?
    var lives: [Live] = []
    var recommended: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMenuBarButtonItem()
        
        //if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
        //    flowLayout.estimatedItemSize = CGSize(width: 1, height:1)
        //}
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogin),
                                               name: Notifications.login.name,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogout),
                                               name: Notifications.logout.name,
                                               object: nil)
        
        prepareBarButtonUI()
        
        getHomeLiveVideo()
        getHomeVideo()
        getGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        appDelegate().canRotate = false
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    func getGame() {
        
        API.getGame { (json, error) in
            if error != nil {
                self.getGame()
            }
            else {
                GameCategory.shared.parseObject(json!["data"])
            }
        }
    }
    
    func getHomeLiveVideo() {
        
        API.getAllLive { (json, error) in
            if error == nil {
                self.onFinishLoadingData(json: json!["data"])
            }
            else {
                self.getHomeLiveVideo()
            }
        }
    }
    
    func onFinishLoadingData( json: JSON ) {
        
        let recommendeddata = json["lives"].arrayValue
        for recommendvideo in recommendeddata {
            let video = Live(withJSON: recommendvideo)
            lives.append(video)
        }
        
        if lives.count > 0 {
            live = lives[0]
            lives.remove(at: 0)
        }
        
        loadingView.stopAnimating()
        collection.reloadData()
    }
    
    func getHomeVideo() {
        API.getAllVideo(4) { (json, error) in
            if error == nil {
                self.onFinishLoadingVideoData(json: json!["data"])
            }
            else {
                self.getHomeVideo()
            }
        }
    }
    
    func onFinishLoadingVideoData( json: JSON ) {
        
        let recommendeddata = json["videos"].arrayValue
        for recommendvideo in recommendeddata {
            let video = Video(withJSON: recommendvideo)
            recommended.append(video)
        }
        
        loadingView.stopAnimating()
        collection.reloadData()
    }
    
    func prepareBarButtonUI() {
        
        var navItems: [UIBarButtonItem] = []
        
//        let btnSearch = UIBarButtonItem(image: UIImage(named:"btn_header_search"),
//                                        style: .plain,
//                                        target: self,
//                                        action: #selector(onSearch(_:)))
//        btnSearch.tintColor = UIColor.white
//
//        navItems.append(btnSearch)
        
        func defaultProfile() -> UIBarButtonItem {
            let btnItem = UIBarButtonItem(image: UIImage(named: "btn_header_profile"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(onProfile(_:)))
            btnItem.tintColor = UIColor.white
            
            return btnItem
        }
        
        if UserProfile.sharedInstance.isLogin() == true {
            
            if let imgURL = UserProfile.sharedInstance.picture, !imgURL.isEmpty {
                let btn_profile = UIButton(type: .custom)
                btn_profile.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                btn_profile.addTarget(self, action: #selector(onProfile(_:)), for: .touchUpInside)
                btn_profile.setBackgroundImage(UIImage(named:"img_friend_2"), for: .normal)
                btn_profile.sd_setBackgroundImage(with: URL(string: imgURL),
                                        for: .normal,
                                        placeholderImage: UIImage(named:"img_friend_2"))
                //btn_profile.imageView?.contentMode = .scaleAspectFit
                //btn_profile.contentMode = .scaleAspectFit
                btn_profile.layer.cornerRadius = btn_profile.frame.size.width / 2.0
                //btn_profile.layer.borderColor = UIColor.white.cgColor
                //btn_profile.layer.borderWidth = 1.0
                btn_profile.layer.masksToBounds = true
                btn_profile.clipsToBounds = true
                
                let btnProfile = UIBarButtonItem(customView: btn_profile)
                btnProfile.tintColor = UIColor.white
                
                navItems.append(btnProfile)
            }
            else {
                navItems.append(defaultProfile())
            }
            
//            let btnMore = UIBarButtonItem(image: UIImage(named: "btn_header_more"),
//                                          style: .plain,
//                                          target: self,
//                                          action: #selector(onMore(_:)))
//            btnMore.tintColor = UIColor.white
//
//            navItems.append(btnMore)
        }
        else {
            navItems.append(defaultProfile())
        }
        self.navigationItem.rightBarButtonItems = navItems.reversed()
    }
    
    func onSearch( _ sender: AnyObject ) {
        
    }
    
    func onProfile( _ sender: AnyObject ) {
        
        if UserProfile.sharedInstance.isLogin() == false {
            
            appDelegate().prepareLogin(completion: { (success) in
                
                if success == true {
                    self.gotoProfile()
                }
                
            })
        }
        else {
            gotoProfile()
        }
        
    }
    
    func onMore( _ sender: AnyObject ) {
        
    }

    func onLogin() {
        prepareBarButtonUI()
    }
    
    func onLogout() {
        prepareBarButtonUI()
    }
    
    func gotoProfile() {
        
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "profileviewcontroller") as! ProfileViewController
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if live == nil {
            return 0
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            if lives.count > 2 {
                return 2
            }
            return lives.count
        }
        
        return recommended.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "livevideocollectioncell", for: indexPath) as! LiveVideoCollectionCell
            
            cell.imgPreview.sd_setImage(with: URL(string: live!.game_image))
            cell.labelTitle.text = live!.title
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recvideocollectioncell", for: indexPath) as! RecVideoCollectionCell
            
            let video = lives[indexPath.row]
            cell.labelTitle.text = video.title
            cell.labelCaster.text = video.caster_name
            cell.imgPreview.sd_setImage(with: URL(string: video.game_image))
            cell.labelVideoLength.text = ""
            cell.labelNumView.text = video.view_count_str + " · " + video.start_at_str
                        
            return cell
        }
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recvideocollectioncell", for: indexPath) as! RecVideoCollectionCell
            
            let video = recommended[indexPath.row]
            cell.labelTitle.text = video.title
            cell.labelCaster.text = video.caster_name
            //cell.imgPreview.sd_setImage(with: URL(string: video.preview_image))
            cell.labelVideoLength.text = ""
            cell.labelNumView.text = video.view_count_str + " · " + video.start_at_str
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mockupcollectioncell", for: indexPath) as! MockupCollectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else if section == 1 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        else if section == 2 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    ///*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.size.width
            let height = (width/16.0)*9.0
            return CGSize(width: width, height: height)
        }
        else if indexPath.section == 1 {
            let width = collectionView.frame.size.width
            let space:CGFloat = 10
            let insetLR:CGFloat = 20
            
            let cellWidth = floor((width - space - insetLR) / 2.0)
            let height = (cellWidth/16.0)*9.0
            return CGSize(width: cellWidth, height: height+86)
        }
        else if indexPath.section == 2 {
            let width = collectionView.frame.size.width
            let space:CGFloat = 10
            let insetLR:CGFloat = 20
            
            let cellWidth = floor((width - space - insetLR) / 2.0)
            let height = (cellWidth/16.0)*9.0
            return CGSize(width: cellWidth, height: height+86)
        }
        
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        else if section == 1 {
            return 10
        }
        else if section == 2 {
            return 10
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.frame.size.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "homeheaderreusableview",
                                                                             for: indexPath) as! HomeHeaderReusableView
            
            if indexPath.section == 1 {
                headerView.labelTitle.text = "Live"
                headerView.labelDesc.text = "\(lives.count+1) Lives"
                headerView.btnSeeAll.removeTarget(self, action: nil, for: .allEvents)
                headerView.btnSeeAll.addTarget(self, action: #selector(onSeeAll(_:)), for: .touchUpInside)
            }
            else if indexPath.section == 2 {
                headerView.labelTitle.text = "Videos"
                headerView.labelDesc.text = "\(recommended.count) Videos"
                headerView.btnSeeAll.removeTarget(self, action: nil, for: .allEvents)
                headerView.btnSeeAll.addTarget(self, action: #selector(onSeeAllVideo(_:)), for: .touchUpInside)
            }
            
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            presentVideo(video_url: live!.live_url, platform: live!.platform)
        }
        else if indexPath.section == 1 {
            let live = lives[indexPath.row]
            presentVideo(video_url: live.live_url, platform: live.platform)
        }
        else if indexPath.section == 2 {
            let video = recommended[indexPath.row]
            presentVideo(video_url: video.video_link, platform: video.platform)
        }
    }
    
    func presentVideo( video_url: String, platform: String ) {
        if platform == "youtube" {
            appDelegate().canRotate = true
            let player:XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: video_url)
            self.present(player, animated: true, completion: nil)
        }
    }
    
    func onSeeAll(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "hometolive", sender: nil)
    }
    
    func onSeeAllVideo(_ sender: AnyObject ) {
        self.performSegue(withIdentifier: "hometorecommended", sender: nil)
    }
}
