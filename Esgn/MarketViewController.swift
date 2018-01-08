//
//  MarketViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/15/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

enum MarketViewType: Int {
    case allgame, game
}

class MarketViewController: MWZBaseViewController {

    var viewtype: MarketViewType = .allgame
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var items: [MarketItem] = []
    var group: [String:[MarketItem]] = [String:[MarketItem]]()
    var configByGame: Bool = false
    var game: Game?
    
    var loadMore: Bool! = true
    var loadingData: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.register(MarketItemCollectionCell.self, forCellWithReuseIdentifier: "marketitemcollectioncell")
        collection.register(UINib.init(nibName: "MarketItemCollectionCell", bundle: nil), forCellWithReuseIdentifier: "marketitemcollectioncell")
        
        collection.register(LoadingFooterCollectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "loadingfootercollectionview")
        collection.register(UINib.init(nibName: "LoadingFooterCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "loadingfootercollectionview")
        
        if viewtype == .allgame {
            loadMarketItem()
        }
        else {
            loadingView.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMarketItem() {
        
        guard loadingData == false else {
            return
        }
        
        loadingData = true
        
        API.getMarketItems(start_at: items.count,
                           game_id: game?.game_id) { (json, error) in
            if error != nil {
                //z debug
            }
            else {
                self.onFinishLoadingData(json!["data"])
            }
            self.loadingData = false
        }
    }
    
    func onFinishLoadingData(_ json: JSON ) {
        
        let itemsdata = json["items"].arrayValue
        for itemdata in itemsdata {
            let item = MarketItem(withJSON: itemdata)
            items.append(item)
            
            if var array: [MarketItem] = group[item.game_id] {
                array.append(item)
                group[item.game_id] = array
            }
            else {
                group[item.game_id] = [item]
            }
        }
        
        if itemsdata.count < 20 {
            loadMore = false
        }
        else {
            loadMore = true
        }
        
        loadingView.stopAnimating()
        collection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "markettoitem" {
            if let vc = segue.destination as? MarketItemViewController {                
                vc.item = sender as! MarketItem
            }
        }
    }
}

extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForGroupGameItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketitembygamecollectioncell", for: indexPath) as! MarketItemByGameCollectionCell
        
        //if configByGame == true {
        //    return cell
        //}
        for view in cell.scrollView.subviews {
            view.removeFromSuperview()
        }        
        
        var startX: Int = 10
        var index: Int = 0
        for itemarray in group {
            let view: GroupGameItemView = .fromNib()
            view.frame.origin.x = CGFloat(startX)
            
            let marketitem = itemarray.value.first!
            let game = GameCategory.shared.game(withGameId: marketitem.game_id)
            
            view.labelGame.text = game?.name ?? marketitem.game_name
            let itemlabel = itemarray.value.count > 1 ? "Items" : "Item"
            view.labelNum.text = String(format: "%d %@", itemarray.value.count, itemlabel)
            view.btnSelected.tag = Int(game?.game_id ?? marketitem.game_id) ?? 0
            view.btnSelected.addTarget(self, action: #selector(onGame(_:)), for: .touchUpInside)
            view.imgView.cornerWithRadius(2.5, borderColor: UIColor.init(white: 1.0, alpha: 0.4), borderWidth: 0.5)
            
            if let imgURL = game?.image_url, !imgURL.isEmpty {
                view.imgView.sd_setImage(with: URL(string:imgURL))
            }
            
            cell.scrollView.addSubview(view)
            
            index += 1
            startX += Int(view.frame.size.width) + 10
        }
        
        cell.scrollView.contentSize = CGSize(width: startX, height: 0)
        if group.count != 0 {
            configByGame = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            if viewtype == .allgame {
                return self.collectionView(collectionView, cellForGroupGameItemAt:indexPath)
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketitemgamecollectioncell", for: indexPath) as! MarketItemGameCollectionCell
            
            if let imgURL = game?.image_url, !imgURL.isEmpty {
                cell.imgView.sd_setImage(with: URL(string:imgURL))
            }
            else {
                cell.imgView.image = nil
            }
            return cell
        }
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "marketitemcollectioncell", for: indexPath) as! MarketItemCollectionCell
        
        let item = items[indexPath.row]
        
        cell.labelTitle.text = item.name
        cell.labelPrice.text = String(format: "%.0f. ฿", item.price)
        cell.ratingStar.rating = item.avg_rate
        
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
        
        cell.btnWishlist.isSelected = item.is_wishlist
        cell.btnWishlist.tag = indexPath.row
        cell.btnWishlist.addTarget(self, action: #selector(onWishlist(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            if viewtype == .allgame {
                return CGSize(width: collectionView.frame.size.width, height: 197)
            }
            
            let width = collectionView.frame.size.width
            let height = (width/16.0)*9.0
            return CGSize(width: width, height: height)
        }
        
        let width = collectionView.frame.size.width
        let space:CGFloat = 10
        let insetLR:CGFloat = 20
        
        let cellWidth = floor((width - space - insetLR) / 2.0)
        let height = (cellWidth/16.0)*9.0
        return CGSize(width: cellWidth, height: height+80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize.zero
        }
        
        if loadMore == false {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            return UICollectionReusableView()
        }
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "marketheaderreusableview",
                                                                             for: indexPath) as! MarketHeaderReusableView
            
            headerView.labelGame.text = ""
            if viewtype == .game {
                headerView.labelGame.text = game?.name ?? items.first?.game_name ?? ""
            }
            
            return headerView
            
            break
        case UICollectionElementKindSectionFooter:
            
            if loadMore == false {
                return UICollectionReusableView()
            }
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "loadingfootercollectionview",
                                                                             for: indexPath) as! LoadingFooterCollectionView
            
            return footerView
            break
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let item = items[indexPath.row]
            self.performSegue(withIdentifier: "markettoitem", sender: item)
        }
    }
    
    func onWishlist( _ sender: AnyObject ) {
        
        let index = (sender as! UIButton).tag
        let item = items[index]
        
        if item.is_wishlist == true {
            removeWishlist(item)
        }
        else {
            addWishlist(item)
        }
    }
    
    func onGame( _ sender: AnyObject ) {
        
        let tag = (sender as! UIButton).tag
        let key = String(tag)
        let items = group[key]
        
        let vc = UIStoryboard(name:"View",bundle: nil).instantiateViewController(withIdentifier: "marketviewcontroller") as! MarketViewController
        vc.viewtype = .game
        vc.game = GameCategory.shared.game(withGameId: key)
        vc.items = items ?? []
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addWishlist(_ item: MarketItem ) {
        ProgressHUD.show(self.navigationController!.view)
        
        WishlistData.shared.addWishlistOnline(withItem: item.item_id) { (json, error) in
            
            ProgressHUD.hiden(self.navigationController!.view, animated: true)
            if error != nil {
                self.showAPIAlertWithError(error)
            }
            else {
                self.collection.reloadData()
            }
        }
    }
    
    func removeWishlist(_ item: MarketItem ) {
        ProgressHUD.show(self.navigationController!.view)
        
        WishlistData.shared.removeWishlistOnline(withItem: item.item_id) { (json, error) in
            ProgressHUD.hiden(self.navigationController!.view, animated: true)
            if error != nil {
                self.showAPIAlertWithError(error)
            }
            else {
                self.collection.reloadData()
            }
        }
        
    }
}

extension MarketViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtBottom == true {
            if loadMore == true {
                loadMarketItem()
            }
        }
    }
}
