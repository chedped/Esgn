//
//  API.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 2/21/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//z launch

let API_Domain = "http://apis.mayawizardgames.com/new_esgn_api_silex_moved/"
func API_Domain(_ path: String) -> String {
    return "\(API_Domain)\(path)"
}

class API: NSObject {

    @discardableResult class func login( withUserName username: String!, password: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["username" : username,
                                   "password" : password,
                                   "uuid" : Utility.appUUID()
                                   ]
        
        request.url = API_Domain("api/user/loginasuser")
        request.data = param
        request.method = .post
        request.mcompletion = completion
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func login( withToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token,
                                   "uuid" : Utility.appUUID()
                                   ]
        
        request.url = API_Domain("api/user/loginbytoken")
        request.data = param
        request.method = .post
        request.mcompletion = completion
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func login( withGoogleToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["google_token" : token,
                                   "uuid" : Utility.appUUID()
        ]
        
        request.url = API_Domain("api/user/loginwithgoogle")
        request.data = param
        request.method = .post
        request.mcompletion = completion
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func login( withFacebook fbid: String!, fbtoken: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["access_token" : fbtoken,
                                   "facebook_id" : fbid,
                                   "uuid" : Utility.appUUID()
        ]
        
        request.url = API_Domain("api/user/loginwithfacebook")
        request.data = param
        request.method = .post
        request.mcompletion = completion
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func logout( withToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/user/logout")
        request.data = param
        request.method = .post
        request.mcompletion = completion
        
        APIManager.sharedInstance.request(request)
        return request
    }

    @discardableResult class func getProfile( withUserId user_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        request.url = API_Domain("api/user/getprofile/" + user_id)
        request.data = nil
        request.method = .get
        request.mcompletion = completion
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getFriendList( withToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/friend/getfriends")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getFriendRequestList( withToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/friend/invite/touser")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func searchFriend( withToken token: String!, keyword: String!, last_id: String?, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        var param: [String:Any] = ["token" : token,
                                   "search_text" : keyword,
                                   "limit" : 30
        ]
        
        if let user_id = last_id {
            param["last_id"] = user_id
        }
        
        request.url = API_Domain("api/friend/search_user")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func addFriend( withToken token: String!, friend_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/friend/invite/" + friend_id)
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func acceptFriend( withToken token: String!, invite_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/friend/invite/accept/" + invite_id)
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func rejectFriend( withToken token: String!, invite_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/friend/invite/reject/" + invite_id)
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func deleteFriend( withToken token: String!, friend_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/friend/delete/" + friend_id)
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func blockFriend( withToken token: String!, friend_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain("api/friend/block/" + friend_id)
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func homeLiveVideo( completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        request.url = API_Domain("api/live/home")
        request.data = nil
        request.method = .get
        request.mcompletion = completion
        
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getAllLive( completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        request.url = API_Domain("api/live/all")
        request.data = nil
        request.method = .get
        request.mcompletion = completion
        
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getAllVideo(_ limit: Int?, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        var path: String = "api/channel/video/all"
        if limit != nil {
            path = "api/channel/video/all?limit=\(limit!)"
        }
        
        request.url = API_Domain(path)
        request.data = nil
        request.method = .get
        request.mcompletion = completion
        //request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getTutorial( completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        request.url = API_Domain("api/tutorial/get")
        request.data = nil
        request.method = .get
        request.mcompletion = completion
        
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getMarketItems( start_at: Int, game_id: String?, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        var param: [String:Any] = ["search_name" : "",
                                   "max_price" : 10000000,
                                   "min_price" : 0,
                                   "sort_by" : "price desc",
                                   "start_number" : start_at,
                                   "get_qty" : 20]
        
        if game_id != nil {
            param["game_id"] = game_id!
        }
        
        request.url = API_Domain("api/market/serach_items")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getMarketItem( withItemId item_id: String, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        request.url = API_Domain(String(format:"api/market/detail/%@", item_id))
        request.data = nil
        request.method = .get
        request.mcompletion = completion        
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func buyMarketItem( withToken token: String, item_id: String, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        let param: [String:Any] = ["token" : token
        ]
        request.url = API_Domain(String(format:"api/market/buy/%@", item_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getGame( completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        
        request.url = API_Domain("api/game/getgames")
        request.data = nil
        request.method = .get
        request.mcompletion = completion
        
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getWishlist( withToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token
        ]
        request.url = API_Domain("api/market/wishlist_items")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func addWishlist( withToken token: String!, item_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token
        ]
        request.url = API_Domain(String(format:"api/market/add_to_wishlist/%@", item_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func removeWishlist( withToken token: String!, item_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token
        ]
        request.url = API_Domain(String(format:"api/market/delete_from_wishlist/%@", item_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getInventoryItems( withToken token: String!, start: Int, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
                                   "sort_by" : "new_coming",
                                   "start_number" : start,
                                   "get_qty" : 20
        ]
        request.url = API_Domain("api/inventory/items")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getItemCode( withToken token: String!, item_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
        ]
        
        request.url = API_Domain(String(format:"api/inventory/code/%@", item_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func sellItem( withToken token: String!, item_id: String!, price: Double, pin: Bool, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
                                   "price" : price,
                                   "pin" : pin ? 1:0
                                   ]
        
        request.url = API_Domain(String(format:"api/inventory/sell/%@", item_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func cancelSellItem( withToken token: String!, item_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
        ]
        
        request.url = API_Domain(String(format:"api/market/cancel_sell/%@", item_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getMembership( withToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
        ]
        request.url = API_Domain("api/membership/user")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getChatroom( withToken token: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
                                   ]
        request.url = API_Domain("api/chat/chatroom")
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func openChatroom( withToken token: String!, friend_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
                                   "friend_id": friend_id
                                   ]
        request.url = API_Domain("api/chat/open/one_on_one")
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func getUnread( withToken token: String!, chatroom_id: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token
        ]
        
        request.url = API_Domain(String(format:"api/chat/%@/get_unread_message",chatroom_id))
        request.data = param
        request.method = .get
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func sendChatMesage( withToken token: String!, chatroom_id: String!,message: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
                                   "message": message
        ]
        request.url = API_Domain(String(format:"api/chat/message/%@", chatroom_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
    
    @discardableResult class func setReadMesage( withToken token: String!, chatroom_id: String!,message_number: String!, completion: APICompletion? ) -> RequestObject {
        
        let request = RequestObject()
        let param: [String:Any] = ["token" : token,
                                   "message_number": message_number
        ]
        request.url = API_Domain(String(format:"api/chat/%@/mark_message_read", chatroom_id))
        request.data = param
        request.method = .post
        request.mcompletion = completion
        request.tokenHeader = true
        
        APIManager.sharedInstance.request(request)
        return request
    }
}
