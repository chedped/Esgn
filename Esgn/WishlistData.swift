
//
//  WishlistData.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/18/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class Wishlist: NSObject {
    var is_sold: Bool!
    var item_id: String!
    var blueprint_id: String!
    var name: String!
    var image: String?
    var game_id: String!
    var game_name: String!
    var mark_price: Float!
    var current_price: Float!
    var desc: String!
    var avg_rate: Double!
    var seller_id: String!
    var seller_username: String!
    var seller_nickname: String!
    var seller_image: String?
    
    var game: Game? {
        return GameCategory.shared.game(withGameId: game_id)
    }
    
    init( withJSON json: JSON ) {
        super.init()
        
        is_sold = json["is_sold"].boolValue
        item_id = json["item_id"].stringValue
        blueprint_id = json["blueprint_id"].stringValue
        name = json["name"].stringValue
        image = json["image"].string
        game_id = json["game_id"].stringValue
        game_name = json["game_name"].stringValue
        mark_price = json["mark_price"].floatValue
        current_price = json["current_price"].floatValue
        desc = json["description"].stringValue
        avg_rate = json["avg_rate"].doubleValue
        seller_id = json["seller_id"].stringValue
        seller_username = json["seller_username"].stringValue
        seller_nickname = json["seller_nickname"].stringValue
        seller_image = json["seller_image"].string
    }
}

class WishlistData: NSObject {

    static let shared: WishlistData = WishlistData()
    
    func isItemInWishlist( itemId item_id: String ) -> Bool! {
        for wishlist_id in wishlists {
            if wishlist_id == item_id {
                return true
            }
        }
        return false
    }
    
    var wishlists: [String] = []
    
    func getWishlist( completion: APICompletion? ) {
        
        API.getWishlist(withToken: UserProfile.sharedInstance.token!) { (json, error) in
            print(error)
            if error == nil {
                self.parseObject(withJSON: json!["data"])
            }            
            completion?(json,error)
        }
    }
    
    func addWishlistOnline(withItem item_id: String, completion: APICompletion?) {
        
        API.addWishlist(withToken: UserProfile.sharedInstance.token!,
                        item_id: item_id) { (json, error) in
                            
                            if error == nil {
                                self.addWishlist(item_id)
                            }
                            
                            completion?(json,error)
        }
    }
    
    func removeWishlistOnline(withItem item_id: String, completion: APICompletion? ) {
        API.removeWishlist(withToken: UserProfile.sharedInstance.token!,
                           item_id: item_id) { (json, error) in
                            
                            if error == nil {
                                self.removeWishlist(item_id)
                            }
                            
                            completion?(json,error)
        }
    }
    
    func addWishlist(_ item_id: String ) {
        
        if let _ = wishlists.index(of: item_id) {
            return
        }
        wishlists.append(item_id)
    }
    
    func removeWishlist(_ item_id: String) {
        
        if let index = wishlists.index(of: item_id) {
            wishlists.remove(at: index)
        }
    }
    
    func parseObject( withJSON json: JSON ) {
        wishlists.removeAll()
        let items = json["items"].arrayValue
        for item in items {
            let wishlist = Wishlist(withJSON: item)
            wishlists.append(wishlist.item_id)
        }
    }
    
}
