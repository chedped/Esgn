//
//  FriendListViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

enum FriendListType: Int {
    case friend, request
}

class FriendListViewController: MWZBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
   
    var list_type: FriendListType = .friend
    var friends: [Friend] = []
    var requests: [Friend] = []
    
    var deleteVC: DeleteFriendAlertController?
    
    weak var navcontroller: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 70
        
        getFriend()
        getRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFriend() {
        
        API.getFriendList(withToken: UserProfile.sharedInstance.token!,
                          completion: { (json, error) in
                            
                            if error == nil {
                                self.onFinishLoadingData(json: json!["data"]["friends"])
                            }
        })
        /*
        if list_type == .friend {
            
            API.getFriendList(withToken: UserProfile.sharedInstance.token!,
                              completion: { (json, error) in
                   
                                if error == nil {
                                    self.onFinishLoadingData(json: json!["data"]["friends"])
                                }
            })
        }
        else {
            API.getFriendRequestList(withToken: UserProfile.sharedInstance.token!,
                                     completion: { (json, error) in
                                        
                                        if error == nil {
                                            self.onFinishLoadingData(json: json!["data"]["invite"])
                                        }
            })
        }*/
    }
    
    func getRequest() {
        API.getFriendRequestList(withToken: UserProfile.sharedInstance.token!,
                                 completion: { (json, error) in
                                    
                                    if error == nil {
                                        self.onFinishLoadingRequestData(json: json!["data"]["invite"])
                                    }
        })
    }
    
    func onFinishLoadingData( json: JSON ) {
        //print(json)
        
        let friendarray = json.arrayValue
        
        var friendtemp = [Friend]()
        
        for friendjson in friendarray {
            let friend = Friend(withJSON: friendjson)
            friendtemp.append(friend)
        }
        
        friends = friendtemp
        
        ChatManager.shared.friends = friends
        
        loadingView.stopAnimating()
        tableView.reloadData()
        
        if self.view.window != nil {
            self.perform(#selector(getFriend), with: nil, afterDelay: 3.0)
        }
    }
    
    func onFinishLoadingRequestData( json: JSON ) {
        //print(json)
        
        let friendarray = json.arrayValue
        
        var friendtemp = [Friend]()
        
        for friendjson in friendarray {
            let friend = Friend(withJSON: friendjson)
            friendtemp.append(friend)
        }
        
        requests = friendtemp
        
        loadingView.stopAnimating()
        tableView.reloadData()
        
        if self.view.window != nil {
            self.perform(#selector(getRequest), with: nil, afterDelay: 3.0)
        }
    }
}


extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return requests.count
        }
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            if requests.count == 0 {
                return nil
            }
        }
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.9)
        
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 5, width: view.frame.size.width-30, height: 20)
        label.textColor = UIColor.white
        label.font = DefaultFont(12)
        
        if section == 0 {
            label.text = "Friend Request (\(requests.count))"
        }
        else {
            label.text = "Friend (\(friends.count))"
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if requests.count == 0 {
                return 0
            }
        }
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if list_type == .friend {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendcell", for: indexPath) as! FriendCell
            
            let friend = friends[indexPath.row]
            
            cell.labelName.text = friend.fullname
            cell.labelNickname.text = friend.display_name
            
            if let imgURL = friend.picture, !imgURL.isEmpty {
                cell.imgProfile.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named:"img_profile_1"))
            }
            else {
                cell.imgProfile.image = UIImage(named:"img_profile_1")
            }
            
            cell.btnMore?.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnMore?.addTarget(self, action: #selector(onMore(_:event:)), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendrequestcell", for: indexPath) as! FriendRequestCell
            
            let friend = requests[indexPath.row]
            
            cell.labelName.text = friend.fullname
            cell.labelNickname.text = friend.display_name
            
            if let imgURL = friend.picture, !imgURL.isEmpty {
                cell.imgProfile.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named:"img_profile_1"))
            }
            else {
                cell.imgProfile.image = UIImage(named:"img_profile_1")
            }
            
            cell.btnAccept.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnDelete.removeTarget(nil, action: nil, for: .allEvents)
            
            cell.btnAccept.addTarget(self, action: #selector(onAccept(_:event:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(onDelete(_:event:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let friend = friends[indexPath.row]
            
            let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "chatviewcontroller") as! ChatViewController
            if let chatroom = ChatManager.shared.chatroom(fromFriendId: friend.friend_id) {
                vc.chatroom = chatroom
            }
            else {
                vc.friend = friend
            }
            navcontroller?.pushViewController(vc, animated: true)
        }
    }
    
    func onAccept( _ sender: AnyObject, event: UIEvent ) {
        guard let cell = sender.superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let friend = requests[indexPath.row]
            API.acceptFriend(withToken: UserProfile.sharedInstance.token!,
                             invite_id: friend.friend_invite_id,
                             completion: { (json, error) in
                                
                                if error == nil {
                                    if let index = self.friends.index(of: friend) {
                                        self.friends.remove(at: index)
                                    }
                                    self.tableView.reloadData()
                                }
                                else {
                                    //z debug
                                }
            })
        }
    }
    
    func onDelete( _ sender: AnyObject, event: UIEvent ) {
        guard let cell = sender.superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let friend = requests[indexPath.row]
            
            API.rejectFriend(withToken: UserProfile.sharedInstance.token!,
                             invite_id: friend.friend_invite_id,
                             completion: { (json, error) in
                                
                                if error == nil {
                                    if let index = self.friends.index(of: friend) {
                                        self.friends.remove(at: index)
                                    }
                                    self.tableView.reloadData()
                                }
                                else {
                                    //z debug
                                }
            })
        }
    }
    
    func onMore( _ sender: AnyObject, event: UIEvent ) {
        guard let cell = sender.superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let friend = friends[indexPath.row]
            let alert = UIAlertController(withStyle: .actionSheet,
                                          title: "Action for this user " + friend.fullname,
                                          message: nil,
                                          cancelTitle: "Cancel")
            
            let delaction = UIAlertAction(title: "Delete Friend",
                                       style: .default,
                                       handler: { (action) in
                                        self.deleteFriend(friend: friend)
            })
            
            let blkaction = UIAlertAction(title: "Block Friend",
                                       style: .default,
                                       handler: { (action) in
                                        self.blockFriend(friend: friend)
            })
            
            alert.addAction(delaction)
            alert.addAction(blkaction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteFriend( friend: Friend ) {
        
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "deletefriendalertcontroller") as! DeleteFriendAlertController
        
        vc.completion = {
            API.deleteFriend(withToken: UserProfile.sharedInstance.token!,
                             friend_id: friend.friend_id) { (json, error) in
                                
                                if error == nil {
                                    
                                    if let index = self.friends.index(of: friend) {
                                        self.friends.remove(at: index)
                                        
                                        self.tableView.reloadData()
                                    }
                                }
                                else {
                                    self.showAPIAlertWithError(error)
                                }
            }
        }
        
        let mainVC = appDelegate().window!.rootViewController
        vc.presentView(inView: mainVC!.view,
                       action: .delete,
                       friend: friend)
        
        deleteVC = vc
    }
    
    func blockFriend( friend: Friend ) {
        
        let vc = UIStoryboard(name: "View", bundle: nil).instantiateViewController(withIdentifier: "deletefriendalertcontroller") as! DeleteFriendAlertController
        
        vc.completion = {
            API.blockFriend(withToken: UserProfile.sharedInstance.token!,
                            friend_id: friend.friend_id) { (json, error) in
                                
                                if error == nil {
                                    
                                    if let index = self.friends.index(of: friend) {
                                        self.friends.remove(at: index)
                                        
                                        self.tableView.reloadData()
                                    }
                                }
                                else {
                                    self.showAPIAlertWithError(error)
                                }
            }
        }
        let mainVC = appDelegate().window!.rootViewController
        vc.presentView(inView: mainVC!.view,
                       action: .block,
                       friend: friend)
        
        deleteVC = vc
    }
}
