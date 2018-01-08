//
//  Membership.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/19/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class Benefit: NSObject {
    var benefit_id: String!
    var desc_th: String!
    var desc_en: String!
    var benefit_unit: String!
    var benefit_type: String!
    var benefit_value: Int!
    
    init( withJSON json: JSON ) {
        super.init()
     
        benefit_id = json["benefit_id"].stringValue
        desc_th = json["description_th"].stringValue
        desc_en = json["description_en"].stringValue
        benefit_unit = json["benefit_unit"].stringValue
        benefit_type = json["benefit_type"].stringValue
        benefit_value = json["benefit_value"].intValue
    }
}

class Membership: NSObject {

    var membership_id: String!
    var membership_name: String!
    var benefits: [Benefit]!
    
    init( withJSON json: JSON ) {
        
        super.init()
        
        membership_id = json["membership_id"].stringValue
        membership_name = json["membership_name"].stringValue
        
        var temp: [Benefit] = []
        let benefitsdata = json["benifit"].arrayValue
        for benefitjson in benefitsdata {
            let benefit = Benefit(withJSON: benefitjson)
            temp.append(benefit)
        }
        
        benefits = temp.sorted(by: { $0.benefit_value > $1.benefit_value })
    }
    
}
