//
//  Recommended.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class Video: NSObject {

    var archive_video_id: String!
    var caster_id: Int!
    var caster_name: String!
    var live_id: String!
    var title: String!
    var desc: String!
    var video_link: String!
    var like_count: Int!
    var platform: String!
    var image: String!
    
    var view_count: Int! = 0
    var start_at: Double!
    /*
    var video_length: String! {
        
        let current = Date()
        
        let interval = Calendar.current.dateComponents([.hour, .minute, .second], from: current, to: Date(timeInterval: current_video_length, since: current))
        
        let text = NSMutableString()
        if let hour = interval.hour, hour > 0 {
            text.appendFormat("%d:", hour)
        }
        
        text.appendFormat("%02d:", interval.minute ?? 0)
        text.appendFormat("%02d", interval.second ?? 0)
        
        return text as String
    }
    */
    var view_count_str: String! {
        
        return "\(view_count!) views"
    }
    
    var start_at_str: String! {
        
        return Date(timeIntervalSince1970: start_at).agoString()
    }
    
    init( withJSON json: JSON ) {
        
        super.init()
        
        parseObject(withJSON: json)
    }
    
    func parseObject( withJSON json: JSON ) {        
        archive_video_id = json["archive_video_id"].stringValue
        title = json["title"].stringValue
        desc = json["description"].stringValue
        view_count = json["view_count"].intValue
        start_at = json["created_at_1970"].doubleValue
        caster_id = json["caster_id"].intValue
        caster_name = json["caster_name"].stringValue
        live_id = json["live_id"].stringValue
        video_link = json["video_link1"].stringValue
        like_count = json["like_count"].intValue
        platform = json["platform"].stringValue
        image = json["image"].stringValue
    }
}
