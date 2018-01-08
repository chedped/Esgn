//
//  FadeInPushSegue.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 3/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class FadeInPushSegue: UIStoryboardSegue {

    var animated: Bool = true
    
    override func perform() {
        
        if var sourceViewController = self.source as? UIViewController, var destinationViewController = self.destination as? UIViewController {
            
            var transition: CATransition = CATransition()
            
            transition.type = kCATransitionFade //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            transition.subtype = kCATransitionFromRight
            
            
            sourceViewController.view.window?.layer.add(transition, forKey: "kCATransition")
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
            
            
        }
    }
}
