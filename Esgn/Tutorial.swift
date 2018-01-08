//
//  Tutorial.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tutorial: NSObject {
    var tutorial_id: String!
    var title: String!
    var image_url: String!
    var desc: String!

    init( withJSON json: JSON ) {
        
        super.init()
        
        parseObject( withJSON: json )
    }
    
    func parseObject( withJSON json: JSON ) {
        
        tutorial_id = json["tutorial_id"].stringValue
        title = json["title"].stringValue
        image_url = json["image_url"].stringValue
        desc = json["description"].stringValue
    }
}
