//
//  MColor.swift
//  iOTalkEGG
//
//  Created by Appsynth on 5/21/2558 BE.
//  Copyright (c) 2558 Appsynth. All rights reserved.
//

import UIKit

class MColor: NSObject {
    
    class func getColorInfo() -> Dictionary<String, String> {
        
        //let themeManager = ASThemeManager.sharedTheme()
        //let path = themeManager.theme.unzip_path + "/MColor-info.plist"
        let path = ""
        
        if FileManager.default.fileExists(atPath: path) {
            if let colorInfo = NSDictionary(contentsOfFile: path) as? Dictionary<String, String> {
                return colorInfo
            }
        }
        else
            if let path = Bundle.main.path(forResource: "MColor-info", ofType: "plist") {
            if let colorInfo = NSDictionary(contentsOfFile: path) as? Dictionary<String, String> {
                return colorInfo
            }
        }
        
        return Dictionary()
    }
    
    class func getColorCode(_ codeStr: String) -> UIColor {
        var colorDict           = MColor.getColorInfo()
        if let hexColorStr: String = colorDict[codeStr]
        {
            return self.Hex(hexColorStr)
        }
        
        return UIColor.black
    }
    
    class func Hex(_ hexStr: String) -> UIColor {
        
        var cString: String     = hexStr.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
