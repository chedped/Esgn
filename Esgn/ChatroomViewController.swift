//
//  ChatroomViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 1/8/18.
//  Copyright © 2018 Maya Wizard. All rights reserved.
//

import UIKit

class ChatroomViewController: MWZBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var chatrooms: [ChatRoom] = []
    
    weak var navcontroller: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatrooms = ChatManager.shared.chatrooms
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onUpdateChatroom(_:)),
                                               name: Notifications.UpdateChatroom.name,
                                               object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onUpdateChatroom(_ notification: Notification) {
        
        chatrooms = ChatManager.shared.chatrooms
        tableView.reloadData()
    }
    
}

extension ChatroomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "chatroomcell", for: indexPath)
        
        let chatroom = chatrooms[indexPath.row]
        
        let friend_name = chatroom.friend?.display_name ?? "Unknown"
        let friend_img = chatroom.friend?.picture
        let lastest_message:String = chatroom.lastest_message
        let unread_count:Int = chatroom.unread_message_count
        let message_time:String = chatroom.lastest_message_time_display
        
        cell.textLabel?.text = friend_name
        cell.detailTextLabel?.text = lastest_message + " (\(unread_count))" + message_time
        if friend_img != nil {
            cell.imageView?.sd_setImage(with: URL(string: friend_img!),
                                        placeholderImage: UIImage(named:"img_friend_1"))
        }
        else {
            cell.imageView?.image = UIImage(named: "img_friend_1")
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatroom = chatrooms[indexPath.row]
        
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "chatviewcontroller") as! ChatViewController
        vc.chatroom = chatroom
        navcontroller?.pushViewController(vc, animated: true)
    }
    
}
