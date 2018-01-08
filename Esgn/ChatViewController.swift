//
//  ChatViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 1/8/18.
//  Copyright © 2018 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChatViewController: MWZBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var chatroom: ChatRoom?
    var friend: Friend?
    var chats: [Chat] = []
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = chatroom?.friend?.display_name ?? friend?.display_name ?? "Unknown"
        openChatroom()
        
        let tap = UITapGestureRecognizer { (gesture, state, point) in
            self.textView.resignFirstResponder()
        }
        self.view.addGestureRecognizer(tap!)
    }
    
    override func onBack(_ sender: AnyObject) {
        
        timer?.invalidate()
        timer = nil
        
        super.onBack(sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openChatroom() {
        
        guard let friend_id = chatroom?.friend?.friend_id ?? friend?.friend_id else {
            return
        }
        
        API.openChatroom(withToken: UserProfile.sharedInstance.token!,
                         friend_id: friend_id) { (json, error) in
                            
                            if error == nil {
                                self.onFinishOpenChatroom(json!["data"])
                            }
                            
        }
    }

    func onFinishOpenChatroom(_ json: JSON) {
        
        if chatroom == nil {
            chatroom = ChatRoom(withJSON: json["result"]["chat_channel"])
        }
        
        let historydata = json["result"]["history"].arrayValue
        for historyjson in historydata {
            let message = Chat(withJSON: historyjson)
            chats.append(message)
        }
        
        loadingView.stopAnimating()
        tableView.reloadData()
        
        self.timer = Timer.scheduledTimer(timeInterval: 3,
                                          target: self,
                                          selector: #selector(onRefreshUnread),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    func onRefreshUnread() {
        
        API.getUnread(withToken: UserProfile.sharedInstance.token!,
                      chatroom_id: chatroom!.chat_channel_id) { (json, error) in
                        
                        if error == nil {
                            self.onFinishLoadingUnread(json!["data"])
                        }
        }
    }
    
    func isAlreadyHaveChat( message: Chat ) -> Bool {
        for chat in chats {
            if chat.message_number == message.message_number {
                return true
            }
        }
        return false
    }
    
    func onFinishLoadingUnread(_ json: JSON ) {
        let historydata = json["result"].arrayValue
        for historyjson in historydata {
            let message = Chat(withJSON: historyjson)
            if isAlreadyHaveChat(message: message) == false {
                chats.append(message)
            }
        }
        if let message = chats.last {
            setReadMessage(message)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func onSend( _ sender: AnyObject ) {
        
        guard let text: String = textView.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            return
        }
        
        sendChatmessage(text)
        textView.text = ""
    }
    
    func setReadMessage(_ message: Chat ) {
        API.setReadMesage(withToken: UserProfile.sharedInstance.token!,
                          chatroom_id: chatroom!.chat_channel_id,
                          message_number: message.message_number!) { (json, error) in
                            
                            if error == nil {
                                message.status = .read
                            }
        }
    }
    
    func sendChatmessage(_ message: String) {
        
        let chat = Chat(withOwnerMessage: message)
        chats.append(chat)
        tableView.reloadData()
        
        API.sendChatMesage(withToken: UserProfile.sharedInstance.token!,
                           chatroom_id: chatroom!.chat_channel_id,
                           message: message) { (json, error) in
                            
                            if error == nil {
                                chat.status = .sent
                                self.tableView.reloadData()
                            }
        }
    }
}

extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath)
        
        let chat = chats[indexPath.row]
        cell.textLabel?.text = chat.message
        
        if UserProfile.sharedInstance.user_id == chat.writer_id {
            cell.backgroundColor = UIColor.blue
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
}
