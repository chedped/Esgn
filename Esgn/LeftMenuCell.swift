//
//  LeftMenuCell.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 9/28/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var labelMenu: UILabel!
    @IBOutlet weak var imgICon: UIImageView!
    @IBOutlet weak var viewBadge: UIView!
    @IBOutlet weak var labelBadge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if UIDevice.isScreen35inch() == true ||
            UIDevice.isScreen4inch() == true {
            labelMenu.font = DefaultFontMedium(18)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
