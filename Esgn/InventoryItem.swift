//
//  InventoryItem.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/18/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

enum InventoryStatus: String {
    case normal = "normal"
    case selling = "selling"
}

class InventoryItem: NSObject {
    var item_id: String!
    var name: String!
    var image: String?
    var game_id: String!
    var game_name: String!
    var base_price: Float!
    var desc: String!
    var avg_rate: Double!
    var status: InventoryStatus!
    
    var game: Game? {
        return GameCategory.shared.game(withGameId: game_id)
    }
    
    init( withJSON json: JSON ) {
        super.init()
        
        item_id = json["item_id"].stringValue
        name = json["name"].stringValue
        image = json["image"].string
        game_id = json["game_id"].stringValue
        game_name = json["game_name"].stringValue
        base_price = json["base_price"].floatValue
        desc = json["description"].stringValue
        avg_rate = json["avg_rate"].doubleValue
        status = InventoryStatus(rawValue: json["status"].stringValue) ?? .normal
    }
}
