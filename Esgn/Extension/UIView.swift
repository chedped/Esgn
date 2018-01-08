//
//  UIView.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 3/22/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit


extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func circleView( withBorderColor color: UIColor, width: CGFloat ) {
        circleView()
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func circleView() {
        if self.frame.size.width != self.frame.size.height {
            return
        }
        
        self.layer.cornerRadius = self.frame.size.width/2.0
        self.layer.masksToBounds = true
    }
    
    func defaultCornerRadius() {
        cornerWithRadius(2.5)
    }
    
    func cornerWithRadius( _ radius: CGFloat! ) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func cornerWithRadius( _ radius: CGFloat!, borderColor: UIColor, borderWidth: CGFloat ) {
        cornerWithRadius(radius)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func roundView( withCorner corner: UIRectCorner, radius: CGFloat ) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func roundView( withCorner corner: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat ) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
        
        let frameLayer = CAShapeLayer()
        frameLayer.frame = self.bounds
        frameLayer.path = maskPath.cgPath
        frameLayer.lineWidth = borderWidth
        frameLayer.strokeColor = borderColor.cgColor
        frameLayer.fillColor = nil
        
        self.layer.addSublayer(frameLayer)
        
    }
    
    func gradientBackgroundColor( withColor color1: UIColor, endColor color2: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func dashLine( withColor color: UIColor, lineDashPattern pattern: [NSNumber]? ) {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.red.cgColor//color.cgColor
        yourViewBorder.lineDashPattern = pattern
        yourViewBorder.frame = self.bounds        
        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
}
