//
//  FriendCell.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/2/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var btnMore: UIButton?
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
