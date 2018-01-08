//
//  BenefitCell.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/19/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class BenefitCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelTitle.preferredMaxLayoutWidth = appDelegate().window!.bounds.size.width - labelTitle.frame.origin.x - 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
