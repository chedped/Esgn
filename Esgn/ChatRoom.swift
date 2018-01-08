//
//  ChatRoom.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 1/8/18.
//  Copyright © 2018 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ChatStatus: Int {
    case sending, sent, failed, read, unread
}

class Chat: NSObject {
    
    var message_number: String?
    var message: String!
    var writer_id: String!
    var writer_name: String!
    var writer_picture: String!
    var status: ChatStatus = .sending
    
    var friend: Friend? {
        return ChatManager.shared.friend(byId: writer_id)
    }
    
    init( withJSON json: JSON ) {
        super.init()
        
        message_number = json["message_number"].stringValue
        message = json["message"].stringValue
        writer_id = json["writer_id"].stringValue
        writer_name = json["writer_name"].stringValue
        writer_picture = json["writer_picture"].stringValue
        status = .read
    }
    
    init( withOwnerMessage message: String ) {
        super.init()
        
        message_number = nil
        self.message = message
        writer_id = UserProfile.sharedInstance.user_id
        writer_name = UserProfile.sharedInstance.display_name
        writer_picture = UserProfile.sharedInstance.picture
        status = .sending
    }
}

class ChatRoom: NSObject {

    var chat_channel_id: String!
    var name: String!
    var lastest_message: String!
    var unread_message_count: Int!
    var lastest_message_time: Double! = 0
    var lastest_message_time_display: String! {
        
        let calendar = Calendar.current
        if calendar.isDateInToday(Date(timeIntervalSince1970: lastest_message_time)) {
            return Utility.stringFromTimeInterval(lastest_message_time, format: "HH:mm", locale: "en_EN")
        }
        else if calendar.isDateInYesterday(Date(timeIntervalSince1970: lastest_message_time)) {
            return "เมื่อวานนี้"
        }
        
        return Utility.stringFromTimeInterval(lastest_message_time, format: "dd/MM/yyyy HH:mm", locale: "en_EN")
    }
    
    var friend_id: String? {
        let subs = chat_channel_id.components(separatedBy: "-")
        if subs.count > 2 {
            let id1 = subs[1]
            let id2 = subs[2]
            
            if UserProfile.sharedInstance.user_id == id1 {
                return id2
            }
            return id1
        }
            
        return nil
    }
    var friend: Friend? {
        
        if let friend_id = self.friend_id {
            return ChatManager.shared.friend(byId: friend_id)
        }
        return nil
    }
    
    init( withJSON json: JSON ) {

        super.init()
        
        chat_channel_id = json["chat_channel_id"].stringValue
        name = json["name"].stringValue
        lastest_message = json["latest_message"].stringValue
        unread_message_count = json["unread_message_count"].intValue
        lastest_message_time = json["latest_message_time_1970"].doubleValue
    }
}

class ChatManager: NSObject {
    
    static let shared = ChatManager()
    
    var chatrooms: [ChatRoom] = []
    var friends: [Friend] = []
    
    var timerUpdate: Timer?
    
    override init() {
        super.init()
    
        timerUpdate = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(refreshChatRoom), userInfo: nil, repeats: true)
        
    }
    
    func chatroom( fromFriendId friend_id: String) -> ChatRoom? {
        for chatroom in chatrooms {
            if chatroom.friend_id == friend_id {
                return chatroom
            }
        }
        return nil
    }
    
    func refreshChatRoom() {
        
        if UserProfile.sharedInstance.isLogin() == false {
            return
        }
        
        API.getChatroom(withToken: UserProfile.sharedInstance.token!) { (json, error) in
            
            if error == nil {
                self.onFinishLoadingChatroom(json!["data"])
            }
        }
        
    }
    
    func onFinishLoadingChatroom(_ json: JSON ) {
        
        chatrooms.removeAll()
        let roomdata = json["chatroom"]["one-on-one"].arrayValue
        for roomjson in roomdata {
            let room = ChatRoom(withJSON: roomjson)
            chatrooms.append(room)
        }
        
        NotificationCenter.default.post(name: Notifications.UpdateChatroom.name, object: nil)
    }
    
    func friend( byId friend_id: String! ) -> Friend? {
        for friend in friends {
            if friend.friend_id == friend_id {
                return friend
            }
        }
        return nil
    }
    
    
}
