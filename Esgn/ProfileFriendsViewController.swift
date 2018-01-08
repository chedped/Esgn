//
//  ProfileFriendsViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/2/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileFriendsViewController: MWZBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var friends: [Friend] = []
    weak var delegate: ProfileDelegate?
    weak var navController: UINavigationController?
    
    var deleteVC: DeleteFriendAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 70
        
        getFriend()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFriend() {
        
        API.getFriendList(withToken: UserProfile.sharedInstance.token!) { (json, error) in
            
            if error == nil {
                self.onFinishLoadingData( json: json!["data"])
            }
        }
    }

    func onFinishLoadingData( json: JSON ) {
        
        let friendarray = json["friends"].arrayValue
        
        for friendjson in friendarray {
            let friend = Friend(withJSON: friendjson)
            friends.append(friend)
        }
        
        tableView.reloadData()
        loadingView.stopAnimating()
        
        if let delegate = self.delegate {
            delegate.profileDidUpdateFriendList(numOfFriends: friends.count)
        }
    }
}

extension ProfileFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30)
        view.backgroundColor = UIColor.init(colorLiteralRed: 33.0/255.0, green: 34.0/255.0, blue: 33.0/255.0, alpha: 0.9)
        
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: view.frame.size.width-40, height: 30)
        label.font = DefaultFontLight(12)
        label.textColor = UIColor.white
        label.text = "All Friends"
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friend = friends[indexPath.row]
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "otherprofileviewcontroller") as! OtherProfileViewController
        
        vc.user_id = friend.friend_id
        vc.user_full_name = friend.fullname
        
        navController?.pushViewController(vc, animated: true)
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
            
            let mainVC = appDelegate().window!.rootViewController
            mainVC!.present(alert, animated: true, completion: nil)
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
