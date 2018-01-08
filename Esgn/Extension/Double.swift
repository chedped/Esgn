//
//  Double.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 3/30/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

extension Double {
    
    var toLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        //formatter.locale = Locale.current
        formatter.locale = Locale(identifier: "th_TH")
    
        return formatter.string(from: NSNumber(value: self))!
    }
    
    var toDecimalString:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //formatter.locale = Locale.current
        formatter.locale = Locale(identifier: "th_TH")
        
        return formatter.string(from: NSNumber(value: self))!
    }
}
