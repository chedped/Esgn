//
//  FadeOutPopSegue.swift
//  AppTaxi
//
//  Created by Somsak Wongsinsakul on 3/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class FadeOutPopSegue: UIStoryboardSegue {

    override func perform() {
        
        if var sourceViewController = self.source as? UIViewController, var destinationViewController = self.destination as? UIViewController {
            
            let transition: CATransition = CATransition()
            
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            
            destinationViewController.view.alpha = 1
            sourceViewController.view.alpha = 1
            sourceViewController.view.window?.layer.add(transition, forKey: "kCATransition")
            sourceViewController.navigationController?.popViewController(animated: false)
        }
    }

}
