//
//  SearchFriendViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchFriendViewController: MWZBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var requestObject: RequestObject?
    var friends: [SearchFriend] = []
    var last_id: String?
    var loadingData: Bool! = false
    var loadMore: Bool! = true
    var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer { (gesture, state, point) in
            self.searchBar.resignFirstResponder()
        }
        self.view.addGestureRecognizer(tapGesture!)
        
        footerView = tableView.tableFooterView
        tableView.rowHeight = 70
        
        searchFriend(text: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let friend = friends[indexPath.row]
        
        let cell: FriendCell?
        
        if friend.friend_status == .friend {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "friendcompletedcell", for: indexPath) as! FriendCompletedCell
            
            (cell as! FriendCompletedCell).labelCompleteText.text = "You are now friend"
            
        }
        else if friend.friend_status == .invited {
            cell = tableView.dequeueReusableCell(withIdentifier: "friendcompletedcell", for: indexPath) as! FriendCompletedCell
            
            (cell as! FriendCompletedCell).labelCompleteText.text = "Requested"
        }
        else if friend.friend_status == .invite {
            cell = tableView.dequeueReusableCell(withIdentifier: "friendrequestcell", for: indexPath) as! FriendRequestCell
            
            (cell as! FriendRequestCell).btnAccept.removeTarget(nil, action: nil, for: .allEvents)
            (cell as! FriendRequestCell).btnDelete.removeTarget(nil, action: nil, for: .allEvents)
            
            (cell as! FriendRequestCell).btnAccept.addTarget(self, action: #selector(onAccept(_:event:)), for: .touchUpInside)
            (cell as! FriendRequestCell).btnDelete.addTarget(self, action: #selector(onDelete(_:event:)), for: .touchUpInside)
        }
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "friendaddcell", for: indexPath) as! FriendAddCell
            
            (cell as! FriendAddCell).btnAdd.removeTarget(nil, action: nil, for: .allEvents)
            (cell as! FriendAddCell).btnAdd.addTarget(self, action: #selector(onAdd(_:event:)), for: .touchUpInside)
        }
        
        cell!.labelName.text = friend.fullname
        cell!.labelNickname.text = friend.display_name
        
        if let imgURL = friend.picture, !imgURL.isEmpty {
            cell!.imgProfile.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named:"img_profile_1"))
        }
        else {
            cell!.imgProfile.image = UIImage(named:"img_profile_1")
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        
        if scrollView.isAtBottom == true {
            if loadMore == true {
                searchFriend(text: searchBar.text ?? "")
            }
        }
    }
    
    
    func onAdd( _ sender: AnyObject, event: UIEvent ) {
        guard let cell = sender.superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
                        
            let friend = friends[indexPath.row]
            API.addFriend(withToken: UserProfile.sharedInstance.token!,
                          friend_id: friend.user_id,
                          completion: { (json, error) in
                            
                            if error == nil {
                                print(json!)
                                friend.friend_status = .invited
                                
                                self.tableView.reloadData()
                            }
                            else {
                                //z debug
                            }
            })
            
        }
    }
    
    func onAccept( _ sender: AnyObject, event: UIEvent ) {
        guard let cell = sender.superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let friend = friends[indexPath.row]
            API.acceptFriend(withToken: UserProfile.sharedInstance.token!,
                             invite_id: friend.friend_invite_id,
                             completion: { (json, error) in
                                
                                if error == nil {
                                    print(json!)
                                    friend.friend_status = .friend
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
            
            let friend = friends[indexPath.row]
            
            API.rejectFriend(withToken: UserProfile.sharedInstance.token!,
                             invite_id: friend.friend_invite_id,
                             completion: { (json, error) in
                                
                                if error == nil {
                                    print(json!)
                                    friend.friend_status = .notfriend
                                    self.tableView.reloadData()
                                }
                                else {
                                    //z debug
                                }
            })
        }
    }
}

extension SearchFriendViewController: UISearchBarDelegate {
    
    func searchFriend( text: String ) {
        
        guard loadingData == false else {
            return
        }
        
        loadingData = true
        
        let request = API.searchFriend(withToken: UserProfile.sharedInstance.token!,
                                       keyword: text,
                                       last_id: last_id,
                                       completion: { (json, error) in
                                        
                                        self.loadingData = false
                                        if error == nil {
                                            self.onFinishSearchData(json: json!["data"])
                                        }
                                            
        })
    }
    
    func onFinishSearchData( json: JSON ) {
        
        let results = json["result"].arrayValue
        for result in results {
            let friend = SearchFriend(withJSON: result)
            friends.append(friend)
        }
        
        loadMore = true
        if results.count < 30 {
            loadMore = false
            tableView.tableFooterView = nil
        }
        else {
            tableView.tableFooterView = footerView
        }
        
        tableView.reloadData()
        last_id = friends.last?.user_id
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*
        guard !searchText.isEmpty else {
            
            friends.removeAll()
            tableView.reloadData()
            return
        }
        */
        last_id = nil
        loadingData = false
        loadMore = true
        tableView.tableFooterView = footerView
        friends.removeAll()
        tableView.reloadData()
        
        searchFriend(text: searchText)        
    }
}
