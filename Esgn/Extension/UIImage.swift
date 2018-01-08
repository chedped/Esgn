//
//  UIImage.swift
//  Skylane
//
//  Created by Somsak Wongsinsakul on 7/27/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }

}
