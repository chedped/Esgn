//
//  InventoryViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/18/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

enum InventoryViewType: Int {
    case allgame, game
}

class InventoryViewController: MWZBaseViewController {
    
    var viewtype: InventoryViewType = .allgame
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var items: [InventoryItem] = []
    var group: [String:[InventoryItem]] = [String:[InventoryItem]]()
    var configByGame: Bool = false
    var game: Game?
    
    var item_count: Int! = 0
    var inventory_slot: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSellingItem(_:)),
                                               name: Notifications.sellingItem.name,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onCancelSellingItem(_:)),
                                               name: Notifications.cancelSellingItem.name,
                                               object: nil)

        if viewtype == .allgame {
            loadInventory()
        }
        else {
            loadingView.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onBack(_ sender: AnyObject) {
        
        NotificationCenter.default.removeObserver(self, name: Notifications.sellingItem.name, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notifications.cancelSellingItem.name, object: nil)
        super.onBack(sender)
    }
    
    func onSellingItem( _ notification: Notification) {
        
        if let info = notification.userInfo {
            if let item_id = info["item_id"] as? String {
                
                for (i,initem) in items.enumerated() {
                    if item_id == initem.item_id {
                        initem.status = .selling
                        break
                    }
                }
                
                if var groupitems = group[item_id] {
                    for (i,initem) in groupitems.enumerated() {
                        if item_id == initem.item_id {
                            initem.status = .selling
                            break
                        }
                    }
                }
                
                collection.reloadData()
            }
        }
    }
    
    func onCancelSellingItem( _ notification: Notification) {
        
        if let info = notification.userInfo {
            if let item_id = info["item_id"] as? String {
                
                for (i,initem) in items.enumerated() {
                    if item_id == initem.item_id {
                        initem.status = .normal
                        break
                    }
                }
                
                if var groupitems = group[item_id] {
                    for (i,initem) in groupitems.enumerated() {
                        if item_id == initem.item_id {
                            initem.status = .normal
                            break
                        }
                    }
                }
                collection.reloadData()
            }
        }
    }
    
    func loadInventory() {
        API.getInventoryItems(withToken: UserProfile.sharedInstance.token!,
                              start: items.count) { (json, error) in
                                
                                if error != nil {
                                    //z debug
                                }
                                else {
                                    self.onFinishLoadingData(json!["data"])
                                }
        }
    }
    
    func onFinishLoadingData(_ json: JSON ) {
        
        let itemsdata = json["items"].arrayValue
        for itemdata in itemsdata {
            let item = InventoryItem(withJSON: itemdata)
            items.append(item)
            
            if var array: [InventoryItem] = group[item.game_id] {
                array.append(item)
                group[item.game_id] = array
            }
            else {
                group[item.game_id] = [item]
            }
        }
        
        item_count = json["item_count"].intValue
        inventory_slot = json["inventory_slot"].intValue
        
        loadingView.stopAnimating()
        collection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "inventorytoitem" {
            if let vc = segue.destination as? InventoryItemViewController {
                vc.delegate = self
                vc.item = sender as! InventoryItem
            }
        }
    }

}

extension InventoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        if configByGame == true {
            return cell
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
            view.imgIcon.image = UIImage(named: "icn_inventory_red")
            
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
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "inventoryitemcollectioncell", for: indexPath) as! InventoryItemCollectionCell
        
        let item = items[indexPath.row]
        
        cell.labelTitle.text = item.name
        
        if let imgURL = item.image, !imgURL.isEmpty {
            cell.imgItem.sd_setImage(with: URL(string:imgURL))
        }
        else {
            cell.imgItem.image = nil
        }
        
        cell.imgGame.image = nil
        if let game = item.game {
            if let imgURL = game.image_url, !imgURL.isEmpty {
                cell.imgGame.sd_setImage(with: URL(string:imgURL)!)
            }
        }
        
        //cell.btnCode.isHidden = item.status == .selling
        
        if item.status == .selling {
            cell.btnSell.setTitle("Selling", for: .normal)
        }
        else {
            cell.btnSell.setTitle("Sell", for: .normal)
        }
        
        cell.btnSell.tag = indexPath.row
        cell.btnCode.tag = indexPath.row
        
        cell.btnCode.addTarget(self, action: #selector(onCode(_:)), for: .touchUpInside)
        cell.btnSell.addTarget(self, action: #selector(onSell(_:)), for: .touchUpInside)
        
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
        return CGSize(width: cellWidth, height: height+90)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            return UICollectionReusableView()
        }
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "marketheaderreusableview",
                                                                             for: indexPath) as! MarketHeaderReusableView
            headerView.labelTitle.text = "ALL INVENTORY"
            
            if viewtype == .game {
                headerView.labelTitle.text = game?.name ?? items.first?.game_name ?? ""
            }
            
            headerView.labelGame.text = String(format:"(%d/%d)", item_count, inventory_slot)
            
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let item = items[indexPath.row]
            self.performSegue(withIdentifier: "inventorytoitem", sender: item)
        }
    }
    
    func onGame( _ sender: AnyObject ) {
        
        let tag = (sender as! UIButton).tag
        let key = String(tag)
        let items = group[key]
        
        let vc = UIStoryboard(name:"View",bundle: nil).instantiateViewController(withIdentifier: "inventoryviewcontroller") as! InventoryViewController
        vc.viewtype = .game
        vc.game = GameCategory.shared.game(withGameId: key)
        vc.items = items ?? []
        vc.inventory_slot = inventory_slot
        vc.item_count = items?.count ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension InventoryViewController {
    
    func onCode( _ sender: AnyObject ) {
        
        let item = items[(sender as! UIButton).tag]
        let title = item.name
        let message = "Item will be removed from inventory after viewing code, please confirm to process it."
        
        let alert = UIAlertController(withStyle: .alert,
                                      title: title,
                                      message: message,
                                      cancelTitle: "Cancel")
        
        let confirm = UIAlertAction(title: "Confirm",
                                    style: .default) { (action) in
                                        
                                        self.requestCode(item)
        }
        
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestCode(_ item: InventoryItem) {
        
        ProgressHUD.show(self.navigationController!.view)
        
        API.getItemCode(withToken: UserProfile.sharedInstance.token!,
                        item_id: item.item_id) { (json, error) in
                            
                            ProgressHUD.hiden(self.navigationController!.view, animated: true)
                            if error != nil {
                                self.showAPIAlertWithError(error)
                            }
                            else {
                                let code = json!["data"]["code"].stringValue
                                self.presentCode(item, code: code)
                            }
        }
    }
    
    func presentCode( _ item: InventoryItem, code: String! ) {
        
        let title = item.name
        let message = String(format: "Serial Promo Code\n\n%@\n\nYou can check this item's code again in history", code)
        
        let alert = UIAlertController(withStyle: .alert,
                                      title: title,
                                      message: message,
                                      cancelTitle: "Done") { (action) in
                                        
                                        self.removeItem(item: item)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func onSell( _ sender: AnyObject ) {
        
        let item = items[(sender as! UIButton).tag]
        
        if item.status == .selling {
            cancelSellItem(item)
            return
        }
        
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "sellitemviewcontroller") as! SellItemViewController
        
        vc.item = item
        
        vc.presentView(inView: self.navigationController!.view)
    }
    
    func cancelSellItem(_ item: InventoryItem) {
        let alert = UIAlertController(withStyle: .alert,
                                      title: item.name,
                                      message: "Do you want to cancel sell this item?",
                                      cancelTitle: "Cancel")
        
        let confirm = UIAlertAction(title: "Confirm",
                                    style: .default) { (action) in
                                        self.doCancelItem(item)
        }
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func doCancelItem(_ item: InventoryItem) {
        
        ProgressHUD.show(self.navigationController!.view)
        
        API.cancelSellItem(withToken: UserProfile.sharedInstance.token!,
                           item_id: item.item_id) { (json, error) in
                            
                            ProgressHUD.hiden(self.navigationController!.view, animated: true)
                            if error != nil {
                                self.showAPIAlertWithError(error)
                            }
                            else {
                                let info: [String:Any] = ["item_id":item.item_id]
                                NotificationCenter.default.post(name: Notifications.cancelSellingItem.name,
                                                                object: nil,
                                                                userInfo: info)
                            }
        }
    }
    
}

extension InventoryViewController: InventoryItemViewDelegate {
    
    func removeItem( item: InventoryItem ) {
        for (i,initem) in items.enumerated() {
            if item.item_id == initem.item_id {
                items.remove(at: i)
                break
            }
        }
        
        if var groupitems = group[item.item_id] {
            for (i,initem) in groupitems.enumerated() {
                if item.item_id == initem.item_id {
                    groupitems.remove(at: i)
                    break
                }
            }
        }
        collection.reloadData()
    }
    
    func inventoryItemViewController(vc: InventoryItemViewController, didViewCodeofItem item: InventoryItem) {
        
        removeItem(item: item)
    }
}
