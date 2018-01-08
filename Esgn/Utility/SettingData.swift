//
//  SettingData.swift
//  Skylane
//
//  Created by Somsak Wongsinsakul on 9/19/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class SettingData: NSObject {

    static let shared: SettingData = SettingData()
    
    var notification: Bool = true
    
    func saveSettingData() {
        
        let settingData : [String:Any] = [ "notification" : notification
                                        ]
        
        UserDefaults.standard.set(settingData, forKey: "settingdata")
        UserDefaults.standard.synchronize()
    }
    
    func loadSettingData() {
        
        if let settingData: [String:Any] = UserDefaults.standard.object(forKey: "settingdata") as? [String:Any] {
            
            notification = settingData["notification"] as! Bool
        }
    }
    
}
