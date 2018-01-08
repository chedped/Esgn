//
//  LiveViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 1/8/18.
//  Copyright © 2018 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON
import XCDYouTubeKit

class LiveViewController: MWZBaseViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var lives: [Live] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Live"
        
        getAllLive()
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
    
    func getAllLive() {
        
        API.getAllLive { (json, error) in
            
            if error == nil {
                self.onFinishLoadingData(json: json!["data"])
            }
        }
    }
    
    func onFinishLoadingData( json: JSON ) {
        
        let recommendeddata = json["lives"].arrayValue
        for recommendvideo in recommendeddata {
            let video = Live(withJSON: recommendvideo)
            lives.append(video)
        }
        
        loadingView.stopAnimating()
        collection.reloadData()
    }
}

extension LiveViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lives.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recvideocollectioncell", for: indexPath) as! RecVideoCollectionCell
        
        let live = lives[indexPath.row]
        cell.labelTitle.text = live.title
        cell.labelCaster.text = live.caster_name
        cell.imgPreview.sd_setImage(with: URL(string: live.game_image))
        cell.labelVideoLength.text = ""
        cell.labelNumView.text = live.view_count_str + " · " + live.start_at_str
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    ///*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        let space:CGFloat = 10
        let insetLR:CGFloat = 20
        
        let cellWidth = floor((width - space - insetLR) / 2.0)
        let height = (cellWidth/16.0)*9.0
        return CGSize(width: cellWidth, height: height+86)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "homeheaderreusableview",
                                                                             for: indexPath) as! HomeHeaderReusableView
            
            headerView.labelTitle.text = "Live"
            headerView.labelDesc.text = "\(lives.count) Lives"
            headerView.btnSeeAll.isHidden = true
            
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let live = lives[indexPath.row]
        
        if live.platform == "youtube" {
            /*
             if let url = URL(string: live.live_url) {
             let player:XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(contentURL: url)
             self.present(player, animated: true, completion: nil)
             }
             else {*/
            appDelegate().canRotate = true
            
            let player:XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: live.live_url)
            self.present(player, animated: true, completion: nil)
            //}
        }
        
    }
}
