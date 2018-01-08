//
//  InventoryItemViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/18/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import Cosmos

protocol InventoryItemViewDelegate: NSObjectProtocol {
    
    func inventoryItemViewController( vc: InventoryItemViewController, didViewCodeofItem item: InventoryItem)
}

class InventoryItemViewController: MWZBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var labelGame: UILabel!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var btnSell: UIButton!
    
    weak var delegate: InventoryItemViewDelegate?
    
    var item: InventoryItem!
    var game: Game? {
        return GameCategory.shared.game(withGameId: item.game_id)
    }
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

        self.navigationItem.title = item.name
        
        labelGame.text = game?.name ?? item!.game_name
        if game != nil {
            if let imgURL = game?.image_url, !imgURL.isEmpty {
                imgGame.sd_setImage(with: URL(string:imgURL)!)
            }
        }
        labelItemName.text = item.name
        ratingStar.rating = item.avg_rate
        
        if let imgURL = item.image, !imgURL.isEmpty {
            imgItem.sd_setImage(with: URL(string: imgURL))
        }
        labelDesc.text = item.desc
        labelDesc.preferredMaxLayoutWidth = appDelegate().window!.bounds.size.width - 20
        
        btnCode.isHidden = item.status == .selling
        if item.status == .selling {
            btnSell.setTitle("Selling", for: .normal)
        }
        else {
            btnSell.setTitle("Sell", for: .normal)
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
                if item.item_id == item_id {
                    self.btnCode.isHidden = true
                    self.btnSell.setTitle("Selling", for: .normal)
                    item.status = .selling
                }
            }
        }
    }
    
    func onCancelSellingItem( _ notification: Notification) {
        
        if let info = notification.userInfo {
            if let item_id = info["item_id"] as? String {
                if item.item_id == item_id {
                    self.btnCode.isHidden = false
                    self.btnSell.setTitle("Sell", for: .normal)
                    item.status = .normal
                }
            }
        }
    }
    
    @IBAction func onCode( _ sender: AnyObject ) {
        
        let title = item.name
        let message = "Item will be removed from inventory after viewing code, please confirm to process it."
        
        let alert = UIAlertController(withStyle: .alert,
                                      title: title,
                                      message: message,
                                      cancelTitle: "Cancel")
        
        let confirm = UIAlertAction(title: "Confirm",
                                    style: .default) { (action) in
                                        
                                        self.requestCode()
        }
        
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestCode() {
        
        ProgressHUD.show(self.navigationController!.view)
        
        API.getItemCode(withToken: UserProfile.sharedInstance.token!,
                        item_id: item.item_id) { (json, error) in
                            
                            ProgressHUD.hiden(self.navigationController!.view, animated: true)
                            if error != nil {
                                self.showAPIAlertWithError(error)
                            }
                            else {
                                let code = json!["data"]["code"].stringValue
                                self.presentCode( code )
                            }
        }
    }
    
    func presentCode( _ code: String! ) {
        
        let title = item.name
        let message = String(format: "Serial Promo Code\n\n%@\n\nYou can check this item's code again in history", code)
        
        let alert = UIAlertController(withStyle: .alert,
                                      title: title,
                                      message: message,
                                      cancelTitle: "Done") { (action) in
                                        
                                        self.delegate?.inventoryItemViewController(vc: self, didViewCodeofItem: self.item)
                                        self.navigationController!.popViewController(animated: true)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSell( _ sender: AnyObject ) {
        
        if item.status == .selling {
            cancelSellItem()
            return
        }
        
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "sellitemviewcontroller") as! SellItemViewController
        
        vc.item = item
        
        vc.presentView(inView: self.navigationController!.view)
    }

    func cancelSellItem() {
        let alert = UIAlertController(withStyle: .alert,
                                      title: item.name,
                                      message: "Do you want to cancel sell this item?",
                                      cancelTitle: "Cancel")
        
        let confirm = UIAlertAction(title: "Confirm",
                                    style: .default) { (action) in
                                        self.doCancelItem()
        }
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func doCancelItem() {
        
        ProgressHUD.show(self.navigationController!.view)
        
        API.cancelSellItem(withToken: UserProfile.sharedInstance.token!,
                           item_id: item.item_id) { (json, error) in
                            
                            ProgressHUD.hiden(self.navigationController!.view, animated: true)
                            if error != nil {
                                self.showAPIAlertWithError(error)
                            }
                            else {
                                let info: [String:Any] = ["item_id":self.item.item_id]
                                NotificationCenter.default.post(name: Notifications.cancelSellingItem.name,
                                                                object: nil,
                                                                userInfo: info)
                            }
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
