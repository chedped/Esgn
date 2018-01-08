//
//  DeleteFriendAlertController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

typealias DeleteFriendCompletion = (Void) -> Void

enum DeleteAlertType: Int {
    case delete, block
}

class DeleteFriendAlertController: MWZBaseViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var completion: DeleteFriendCompletion?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.preferredMaxLayoutWidth = appDelegate().window!.bounds.size.width - 100 - 20
        labelDesc.preferredMaxLayoutWidth = appDelegate().window!.bounds.size.width - 100 - 20
        
        self.view.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentView( inView: UIView!, action: DeleteAlertType, friend: Friend ) {
        
        inView.addSubview(self.view)
        
        
        if let imgURL = friend.picture, !imgURL.isEmpty {
            imgProfile.sd_setImage(with: URL(string: imgURL))
        }
        else {
            imgProfile.image = UIImage(named: "img_friend_2")
        }
        
        if action == .delete {
            labelTitle.text = "Are you sure to delete friend?"
            labelDesc.text = friend.fullname + " won't able to see or contact you on ESGN."
            btnDelete.setTitle("Delete", for: .normal)
        }
        else {
            labelTitle.text = "Are you sure to block friend?"
            labelDesc.text = friend.fullname + " won't able to see or contact you on ESGN."
            btnDelete.setTitle("Block", for: .normal)
        }        
        
        
        UIView.animate(withDuration: 0.15,
                       animations: {
                        self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.view.alpha = 1
        }) { (finished) in
            
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.15,
                       animations: {
                        self.contentView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
                        self.view.alpha = 0
        }) { (finished) in
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func onAction( _ sender: AnyObject ) {
        
        if completion != nil {
            completion!()
        }
        
        dismiss()
    }
    
    @IBAction func onClose( _ sender: AnyObject ) {
        
        dismiss()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
