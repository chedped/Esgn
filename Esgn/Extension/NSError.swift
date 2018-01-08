//
//  NSError.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 4/19/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import Foundation
import SwiftyJSON

extension NSError {
    
    convenience init( fromJSON json: JSON! ) {
        
        let friendly_msg = json["friendly_msg_en"].string ?? ""
        let open_link = json["open_link"].string ?? ""
        let is_cancel_open_link = json["is_cancel_open_link"].intValue
        let forcelogout = json["force_logout"].int ?? 0
        let debug_desc = json["debug_desc"].string ?? ""
        
        let userinfo: [String:Any] = [ NSLocalizedFailureReasonErrorKey : debug_desc as NSString,
                                       NSLocalizedDescriptionKey : friendly_msg as NSString,
                                       "error_code" : json["error_code"].intValue as NSNumber,
                                       "force_logout" : forcelogout as NSNumber,
                                       "open_link" : open_link as NSString,
                                       "is_cancel_open_link" : is_cancel_open_link as NSNumber]
        
        self.init(domain: Utility.bundleIdentifier(), code: 9999, userInfo: userinfo)
    }
}
