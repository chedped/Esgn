//
//  WishlistViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/18/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class WishlistViewController: MWZBaseViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var items: [Wishlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.register(MarketItemCollectionCell.self, forCellWithReuseIdentifier: "marketitemcollectioncell")
        collection.register(UINib.init(nibName: "MarketItemCollectionCell", bundle: nil), forCellWithReuseIdentifier: "marketitemcollectioncell")
        
        loadWishlist()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWishlist() {
        
        WishlistData.shared.getWishlist { (json, error) in
            if error == nil {
                
                self.onFinishLoadingData(json!)
            }
        }
    }

    func onFinishLoadingData(_ json: JSON) {
        
        let itemdata = json["data"]["items"].arrayValue
        for item in itemdata {
            let wishlist = Wishlist(withJSON: item)
            items.append(wishlist)
        }
        
        loadingView.stopAnimating()
        collection.reloadData()
    }
}

extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "marketitemcollectioncell", for: indexPath) as! MarketItemCollectionCell
        
        let item = items[indexPath.row]
        
        cell.labelTitle.text = item.name
        cell.labelPrice.text = String(format: "%.0f. ฿", item.mark_price)
        cell.ratingStar.rating = item.avg_rate
        cell.imgGame.image = nil
        
        if let game = item.game {
            if let imgURL = game.image_url, !imgURL.isEmpty {
                cell.imgGame.sd_setImage(with: URL(string: imgURL)!)
            }
            else {
                cell.imgGame.image = nil
            }
        }
        
        if let imgURL = item.image, !imgURL.isEmpty {
            cell.imgItem.sd_setImage(with: URL(string:imgURL))
        }
        else {
            cell.imgItem.image = nil
        }
        
        cell.btnWishlist.isSelected = true
        cell.btnWishlist.tag = indexPath.row
        cell.btnWishlist.addTarget(self, action: #selector(onWishlist(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        let space:CGFloat = 10
        let insetLR:CGFloat = 20
        
        let cellWidth = floor((width - space - insetLR) / 2.0)
        let height = (cellWidth/16.0)*9.0
        return CGSize(width: cellWidth, height: height+80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "marketheaderreusableview",
                                                                             for: indexPath) as! MarketHeaderReusableView
            
            headerView.labelTitle.text = "Wishlist"
            headerView.labelGame.text = String(format:"(%d/%d)", items.count, items.count)
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "marketitemviewcontroller") as! MarketItemViewController
        vc.wishlist_item_id = item.item_id
        vc.wishlist_item_name = item.name
        
        appDelegate().mainNavigation?.pushViewController(vc, animated: true)
    }
    
    func onWishlist( _ sender: AnyObject ) {
        
        let index = (sender as! UIButton).tag
        let item = items[index]
        
        removeWishlist(item)
    }
    
    func removeWishlist(_ item: Wishlist ) {
        
        ProgressHUD.show(appDelegate().window!.rootViewController!.view)
        
        WishlistData.shared.removeWishlistOnline(withItem: item.item_id) { (json, error) in
            ProgressHUD.hiden(appDelegate().window!.rootViewController!.view, animated: true)
            if error != nil {
                self.showAPIAlertWithError(error)
            }
            else {
                
                var index: Int? = nil
                for (i,wishlist) in self.items.enumerated() {
                    if wishlist.item_id == item.item_id {
                        index = i
                        break
                    }
                }
                if index != nil {
                    self.items.remove(at: index!)
                }
                
                self.collection.reloadData()
            }
        }
        
    }
}
