//
//  Live.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 1/5/18.
//  Copyright © 2018 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class Live: NSObject {
    var live_id: String!
    var tournament_id: String!
    var title: String!
    var name: String!
    var logo: String!
    var live_url: String!
    var match_id: String!
    var first_contestant_id: String!
    var first_contestant_name: String!
    var first_contestant_image: String!
    var second_contestant_id: String!
    var second_contestant_name: String!
    var second_contestant_image: String!
    
    var caster_id: String!
    var caster_name: String!
    var caster_image: String!
    var game_id: String!
    var game_name: String!
    var game_image: String!
    var total_viewer: Int!
    var receive_flower: Int!
    var chat_channel: String!
    var platform: String!
    var start_at_1970: Double!

    var view_count_str: String! {
        
        return "\(total_viewer!) watching"
    }
    
    var start_at_str: String! {
        
        return Date(timeIntervalSince1970: start_at_1970).agoString()
    }
    
    init( withJSON json: JSON ) {
        super.init()
        
        live_id = json["live_id"].stringValue
        tournament_id = json["tournament_id"].stringValue
        title = json["title"].stringValue
        name = json["name"].stringValue
        logo = json["logo"].stringValue
        live_url = json["live_url"].stringValue
        match_id = json["match_id"].stringValue
        first_contestant_id = json["first_contestant_id"].stringValue
        first_contestant_name = json["first_contestant_name"].stringValue
        first_contestant_image = json["first_contestant_image"].stringValue
        second_contestant_id = json["second_contestant_id"].stringValue
        second_contestant_name = json["second_contestant_name"].stringValue
        second_contestant_image = json["second_contestant_image"].stringValue
        caster_id = json["caster_id"].stringValue
        caster_name = json["caster_name"].stringValue
        caster_image = json["caster_image"].stringValue
        game_id = json["game_id"].stringValue
        game_name = json["game_name"].stringValue
        game_image = json["game_image"].stringValue
        total_viewer = json["total_viewer"].intValue
        receive_flower = json["receive_flower"].intValue
        chat_channel = json["chat_channel"].stringValue
        platform = json["platform"].stringValue
        start_at_1970 = json["start_at_1970"].doubleValue
    }
    
}
