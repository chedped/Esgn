//
//  MarketItemViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/15/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON

class MarketItemViewController: MWZBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var viewBuy: UIView!
    
    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var labelSeller: UILabel!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var labelGame: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var labelConfirmPrice: UILabel!
    @IBOutlet weak var labelConfirmFee: UILabel!
    @IBOutlet weak var labelConfirmNet: UILabel!
    
    
    var item: MarketItem?
    var game: Game? {
        guard let item = self.item else {
            return nil
        }
        
        return GameCategory.shared.game(withGameId: item.game_id)
    }
    var wishlist_item_id: String?
    var wishlist_item_name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if item != nil {
            self.navigationItem.title = item?.name
        }
        else {
            self.navigationItem.title = wishlist_item_name
            loadMarketItem()
        }
        
        scrollView.isHidden = true
        viewBuy.isHidden = true
        
        prepareItem()
        labelDesc.preferredMaxLayoutWidth = appDelegate().window!.bounds.size.width - 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMarketItem() {
        
        guard let item_id = wishlist_item_id else {
            return
        }
        
        API.getMarketItem(withItemId: item_id) { (json, error) in
            
            if error == nil {
                self.onFinishLoadingData(json!["data"])
            }
            else {
                self.showAPIAlertWithError(error, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func onFinishLoadingData(_ json: JSON ) {
        
        item = MarketItem(withJSON: json["item"])
        prepareItem()
    }
    
    func prepareItem() {
        if item != nil {
            labelGame.text = game?.name ?? item!.game_name
            if game != nil {
                if let imgURL = game?.image_url, !imgURL.isEmpty {
                    imgGame.sd_setImage(with: URL(string:imgURL)!)
                }
            }
            labelSeller.text = item!.seller_nickname
            labelItemName.text = item!.name
            labelPrice.text = String(format: "%.0f ฿", item!.price)
            ratingStar.rating = item!.avg_rate
            
            if let imgURL = item!.image, !imgURL.isEmpty {
                imgItem.sd_setImage(with: URL(string: imgURL))
            }
            labelDesc.text = item!.desc
            
            loadingView.stopAnimating()
            scrollView.isHidden = false
            viewBuy.isHidden = false
            
            labelConfirmPrice.text = String(format: "%.0f ฿", item!.price)
            labelConfirmFee.text = String(format: "%.0f ฿", item!.fee)
            labelConfirmNet.text = String(format: "%.0f ฿", item!.total_price)
        }
    }
    
    @IBAction func onBuy( _ sender: AnyObject ) {
        
        self.scrollView.contentInset.bottom = viewConfirm.frame.size.height
        viewConfirm.isHidden = false
    }
    
    @IBAction func onConfirm( _ sender: AnyObject ) {
        
        guard let item = self.item else {
            return
        }
        
        ProgressHUD.show(self.navigationController!.view)
        
        API.buyMarketItem(withToken: UserProfile.sharedInstance.token!,
                          item_id: item.item_id) { (json, error) in
            ProgressHUD.hiden(self.navigationController!.view, animated: true)
            if error == nil {
                self.showAPIAlertWithMessage("ซื้อไอเทมสำเร็จแล้ว",
                                             completion: {
                                                self.navigationController?.popViewController(animated: true)
                })
            }
            else {
                self.showAPIAlertWithError(error)
            }
        }
    }
}
