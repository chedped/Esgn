//
//  Date.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 7/14/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

extension Date {
    
    func agoString() -> String! {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return Utility.stringFromDate(self, format: "dd MMM yyyy", locale: "en_EN")
        }
        else if let month = interval.month, month > 0 {
            return Utility.stringFromDate(self, format: "dd MMM yyyy", locale: "en_EN")
        }
        else if let day = interval.day, day > 0 {
            
            if day > 7 {
                return Utility.stringFromDate(self, format: "dd MMM yyyy", locale: "en_EN")
            }
            return day == 1 ? "Yesterday" :
                "\(day)" + " " + "days ago"
        }
        else if let hour = interval.hour, hour > 0 {
            
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        }
        else if let minute = interval.minute, minute > 0 {
            return minute < 5 ? "Just Now" :
                "\(minute)" + " " + "minutes ago"
        }
        
        return "Just Now"
    }

}
