//
//  ProfileMembershipViewController.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/2/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileMembershipViewController: MWZBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var labelMembership: UILabel!
    @IBOutlet weak var imgMembership: UIImageView!
    
    var membership: Membership?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isHidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        getMembership()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getMembership() {
        
        API.getMembership(withToken: UserProfile.sharedInstance.token!) { (json, error) in
            if error == nil {
                self.onFinishLoadingData(json!["data"])
            }
        }
    }
    
    func onFinishLoadingData(_ json: JSON) {
        let memberships = json["membership"].arrayValue
        
        if let member = memberships.first {
            membership = Membership(withJSON: member)
        }
        
        labelMembership.text = membership?.membership_name.uppercased()
        let imgMemberName = "icn_member_" + (membership?.membership_id)!
        imgMembership.image = UIImage(named: imgMemberName)
        
        tableView.isHidden = false
        tableView.reloadData()
        loadingView.stopAnimating()
    }
}

extension ProfileMembershipViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let member = membership else {
            return 0
        }
        
        return member.benefits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "benefitcell", for: indexPath) as! BenefitCell
        
        let benefit = membership?.benefits[indexPath.row]
        cell.labelTitle.text = benefit?.desc_th
        
        let imgName = benefit?.benefit_value == 0 ? "icn_lock" : "icn_get"
        cell.imgIcon.image = UIImage(named: imgName)
        
        cell.labelTitle.textColor = benefit?.benefit_value == 0 ? UIColor.gray : UIColor.white
        
        return cell
    }
}
