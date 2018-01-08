//
//  LiveVideoCollectionCell.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class LiveVideoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelTitle.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width-20
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
        //let screenWidth = UIScreen.main.bounds.size.width-1
        //widthConstraint.constant = screenWidth
    }
}

