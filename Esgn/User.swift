//
//  User.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 1/5/18.
//  Copyright © 2018 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {

    var user_id: String!
    var token: String? = nil
    var username: String!
    
    var online_status: Bool!
    var firstname: String!
    var lastname: String!
    var fullname: String! {
        
        return firstname + " " + lastname
    }
    
    var nickname: String!
    var picture: String!
    var email: String!
    var gender: Gender! = .unknown
    var phone_number: String?
    var display_name: String!
    var address: String?
    var birthday: Double!
    
    var followers: Int!
    var video: Int!
    var friend_count: Int!
    var subscriber: Int!
    
    var twitter_link: String?
    var instagram_link: String?
    var youtube_link: String?
    var facebook_link: String?
    var twitch_link: String?
    var facebook_id: String?
    var google_id: String?
    
    var exp_point: Int!
    var member_class_id: String?
    var member_class_name: String?
    
    var wallet: Int!
    var diamond: Int!
    var gold: Int!
    var level: Int!
    
    init( withJSON json: JSON ) {
        super.init()
        
        parseObject(json)
    }
    
    func parseObject( _ profile: JSON ) {
        
        user_id = profile["user_id"].stringValue
        username = profile["username"].stringValue
        
        online_status = (Int(profile["online_status"].stringValue) == 1) ? true:false
        firstname = profile["firstname"].stringValue
        lastname = profile["lastname"].stringValue
        nickname = profile["nickname"].stringValue
        picture = profile["picture"].string
        email = profile["email"].stringValue
        
        if let gen = profile["gender"].string, !gen.isEmpty {
            if let gender = Gender(rawValue: gen) {
                self.gender = gender
            }
            else {
                gender = .unknown
            }
        }
        else {
            gender = .unknown
        }
        
        phone_number = profile["phone_number"].string
        display_name = profile["display_name"].stringValue
        address = profile["address"].string
        birthday = profile["birthday"].doubleValue
        
        twitter_link = profile["twitter_link"].string
        instagram_link = profile["instagram_link"].string
        youtube_link = profile["youtube_link"].string
        facebook_link = profile["facebook_link"].string
        twitch_link = profile["twitch_link"].string
        facebook_id = profile["facebook_id"].string
        google_id = profile["google_id"].string
        
        exp_point = profile["exp_point"].intValue
        member_class_id = profile["member_class_id"].stringValue
        member_class_name = profile["member_class_name"].string
        
        wallet = profile["wallet"].intValue
        diamond = profile["diamond"].intValue
        gold = profile["gold"].intValue
        level = profile["level"].intValue
        
        followers = profile["follower_count"].intValue
        video = profile["video_count"].intValue
        friend_count = profile["friend_count"].intValue
        subscriber = profile["subscriber"].intValue
    }
}
