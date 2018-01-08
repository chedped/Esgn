//
//  xString.swift
//  iOTalkEGG
//
//  Created by Appsynth on 5/19/2558 BE.
//  Copyright (c) 2558 Appsynth. All rights reserved.
//

import Foundation
import UIKit

extension String {
    //MARK: Validation
    var isEmail:Bool {
        get {
            let Format = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let RegEx = NSPredicate(format: "SELF MATCHES %@", Format)
            
            return RegEx.evaluate(with: self)
        }
    }
    
    var isNumberInt:Bool {
        get {
            let Format = "[0-9]+"
            let RegEx = NSPredicate(format: "SELF MATCHES %@", Format)
            
            return RegEx.evaluate(with: self)
        }
    }
    
    var isNumberFloat:Bool {
        get {
            let Format = "^[0-9]+.?[0-9]+"
            let RegEx = NSPredicate(format: "SELF MATCHES %@", Format)
            
            return RegEx.evaluate(with: self)
        }
    }
    
    var isPassword:Bool {
        get {
            let Format = "[\\S]{8,16}"
            let RegEx = NSPredicate(format: "SELF MATCHES %@", Format)
            return RegEx.evaluate(with: self)
        }
    }
    
    var isThId: Bool {
        get {
            let Format = "^\\d{13}"//Only check length 10 digit
            let RegEx = NSPredicate(format: "SELF MATCHES %@", Format)
            return RegEx.evaluate(with: self)
        }
    }
    
    var isPhoneNumber: Bool {
        get {
            let Format = "^\\d{10}"//Only check length 10 digit
            let RegEx = NSPredicate(format: "SELF MATCHES %@", Format)
            return RegEx.evaluate(with: self)
        }
    }
    
    var toNumberFormat: String! {
        if let largeNumber = Int(self) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            return numberFormatter.string(from: NSNumber(value: largeNumber)) ?? ""
        }
        return ""
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    /*
    //MARK: Encrypt
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: (hash as String))
    }
*/
}
