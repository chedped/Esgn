//
//  UserProfile.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 2/21/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON
import FBSDKLoginKit
import GoogleSignIn

enum Gender: String {
    case male = "M"
    case female = "F"
    case unknown
}

class UserProfile: NSObject {

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
    
    
    static let sharedInstance = UserProfile()
    
    func parseToken( _ json: JSON ) {
        if let tokenString = json["token"].string {
            token = tokenString
        }
    }
    
    func parseObject( _ profile: JSON ) {
        
        //let profile = json["user"]
        print(profile)
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
        subscriber = profile["subscriber"].intValue
    }
    
    func isLogin() -> Bool {
        
        if let _ = token {
            return true
        }
        return false
    }
    
    func loadData() {
        
        if let saveData : [String : AnyObject] = UserDefaults.standard.object(forKey: "profile") as? [String:AnyObject] {
            
            let json = JSON(saveData)
            
            self.parseObject(json["user"])
            self.parseToken(json)
        }
    }
    
    func saveData() {
        
        var profile : [String:Any] = [
            
            "online_status" : online_status,
            "lastname" : lastname,
            "firstname" : firstname,
            "user_id" : user_id,
            "nickname" : nickname,
            "gender" : gender.rawValue,
            "email" : email,
            "display_name" : display_name,
            "exp_point" : exp_point,
            "username" : username
        ]
        
        if picture != nil {
            profile["picture"] = picture
        }
        
        if phone_number != nil {
            profile["phone_number"] = phone_number!
        }
        
        if address != nil {
            profile["address"] = address!
        }

        if instagram_link != nil {
            profile["instagram_link"] = instagram_link!
        }
        
        if twitter_link != nil {
            profile["twitter_link"] = twitter_link!
        }
        
        if youtube_link != nil {
            profile["youtube_link"] = youtube_link!
        }
        
        if facebook_link != nil {
            profile["facebook_link"] = facebook_link!
        }
        
        if twitch_link != nil {
            profile["twitch_link"] = twitch_link!
        }
        
        if facebook_id != nil {
            profile["facebook_id"] = facebook_id!
        }
        
        if google_id != nil {
            profile["google_id"] = google_id!
        }
        
        if member_class_id != nil {
            profile["member_class_id"] = member_class_id!
        }
        
        var userData : [String:Any] = ["user" : profile
        ]
        
        if token != nil {
            userData["token"] = token!
        }
        
        UserDefaults.standard.set(userData, forKey: "profile")
        UserDefaults.standard.synchronize()
    }
    
    func resetProfile() {
        user_id = ""
        username = ""
        
        online_status = false
        firstname = ""
        lastname = ""
        nickname = ""
        picture = nil
        email = ""
        gender = .unknown
        phone_number = nil
        display_name = ""
        address = nil
        
        twitter_link = nil
        instagram_link = nil
        youtube_link = nil
        facebook_link = nil
        twitch_link = nil
        facebook_id = nil
        google_id = nil
        exp_point = 0
        member_class_id = nil
        subscriber = 0
        
        token = nil
    }
    
    func logout() {
        
        WishlistData.shared.wishlists.removeAll()
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        resetProfile()
        
        UserDefaults.standard.removeObject(forKey: "profile")
        UserDefaults.standard.synchronize()
    }
}
