//
//  APIRequest.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 2/21/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias APICompletion = (_ json: JSON?, _ error: Error?) -> Void

class RequestObject: NSObject {
    
    var url: String!
    var method: HTTPMethod! = .get
    var data: [String:Any]?
    var mcompletion: APICompletion?
    var request: Request!
    var tokenHeader: Bool = false
    
    func request( _ completion: @escaping (DataResponse<Data>) -> Void) {
        
        if data == nil {
            data = [String:Any]()
        }
        
        data!["uuid"] = Utility.appUUID()
        data!["platform"] = "iOS"
        data!["version"] = Utility.appVersion()
        data!["bundle_id"] = Utility.bundleIdentifier()
        
        var header: [String:String]? = nil
        if tokenHeader == true {
            if let token = data!["token"] as? String {
                header = ["token": token]
            }
        }
        
        let request = Alamofire.request(url,
                                        method: method,
                                        parameters: data,
                                        encoding: URLEncoding.default,
                                        headers: header)
        
        self.request = request.responseData(completionHandler: completion)
    }
}

class APIManager : NSObject {
    
    static let sharedInstance = APIManager()
    
    var requests: [RequestObject] = [RequestObject]()
    
    func request( _ object: RequestObject! ) {
        
        object.request { (response) in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    let json = JSON(data: value)
                    
                    if json["status"].intValue == 0 {
                        print(json)
                        if object.mcompletion != nil {
                            object.mcompletion!(json, NSError(fromJSON: json))
                        }
                    }
                    else {
                        if object.mcompletion != nil {
                            object.mcompletion!(json, nil)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                if object.mcompletion != nil {
                    object.mcompletion!(nil, error)
                }
            }
            
            if let index = self.requests.index(of: object) {
                self.requests.remove(at:index)
            }
        }
        self.requests.append(object)
    }
}
