//
//  UIColor.swift
//  AppTaxiDriver
//
//  Created by Somsak Wongsinsakul on 6/22/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}
