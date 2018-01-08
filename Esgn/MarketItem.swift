//
//  MarketItem.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/15/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class MarketItem: NSObject {    
    var item_id: String!
    var blueprint_id: String!
    var name: String!
    var image: String?
    var game_id: String!
    var game_name: String!
    var price: Float!
    var fee_rate: Float!
    var fee: Float!
    var total_price: Float!
    var pin: Bool!
    var highlight: Bool!
    var desc: String!
    var avg_rate: Double!
    var owner: Bool!
    var seller_id: String!
    var seller_username: String!
    var seller_nickname: String!
    var seller_image: String?
    
    var is_wishlist: Bool! {
        return WishlistData.shared.isItemInWishlist(itemId: item_id)
    }
    
    var game: Game? {
        return GameCategory.shared.game(withGameId: game_id)
    }
    
    init( withJSON json: JSON ) {
        super.init()
        
        item_id = json["item_id"].stringValue
        blueprint_id = json["blueprint_id"].stringValue
        name = json["name"].stringValue
        image = json["image"].string
        game_id = json["game_id"].stringValue
        game_name = json["game_name"].stringValue
        price = json["price"].floatValue
        fee_rate = json["fee_rate"].floatValue
        fee = json["fee"].floatValue
        total_price = json["total_price"].floatValue
        pin = json["pin"].boolValue
        highlight = json["highlight"].boolValue
        desc = json["description"].stringValue
        avg_rate = json["avg_rate"].doubleValue
        owner = json["owner"].boolValue
        seller_id = json["seller_id"].stringValue
        seller_username = json["seller_username"].stringValue
        seller_nickname = json["seller_nickname"].stringValue
        seller_image = json["seller_image"].string
        
    }
    
}
