//
//  Friend.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/2/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

enum FriendStatus: String {
    
    case friend = "friend"
    case invited = "invited"
    case invite = "invite"
    case notfriend = ""
}

class SearchFriend: NSObject {
    var user_id: String!
    var firstname: String!
    var lastname: String!
    var picture: String!
    var display_name: String!
    var friend_invite_id: String!
    var friend_status: FriendStatus!
    
    var fullname: String! {
        
        return firstname + " " + lastname
    }
    
    init( withJSON json: JSON) {
        super.init()
        
        parseObject( withJSON: json )
    }
    
    func parseObject( withJSON json: JSON ) {
        
        user_id = json["user_id"].stringValue
        firstname = json["firstname"].stringValue
        lastname = json["lastname"].stringValue
        picture = json["picture"].stringValue
        display_name = json["nickname"].stringValue
        friend_invite_id = json["friend_invite_id"].stringValue
        friend_status = FriendStatus(rawValue: json["friend_status"].stringValue)
    }
    
}

class Friend: NSObject {

    var friend_id: String!
    var firstname: String!
    var lastname: String!
    var picture: String!
    var display_name: String!
    var friend_invite_id: String!
    
    var fullname: String! {
        
        return firstname + " " + lastname
    }
    
    init( withJSON json: JSON) {
        super.init()
        
        parseObject( withJSON: json )
    }
    
    func parseObject( withJSON json: JSON ) {
        
        friend_id = json["friend_id"].stringValue
        
        if friend_id == nil || friend_id.isEmpty == true {
            friend_id = json["inviter_id"].stringValue
        }
        
        
        firstname = json["firstname"].stringValue
        lastname = json["lastname"].stringValue
        picture = json["picture"].stringValue
        display_name = json["nickname"].stringValue
        friend_invite_id = json["friend_invite_id"].stringValue
    }
}
