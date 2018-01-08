//
//  RecVideoCollectionCell.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 10/3/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

class RecVideoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCaster: UILabel!
    @IBOutlet weak var labelNumView: UILabel!
    @IBOutlet weak var labelVideoLength: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
        ///let screenWidth = (UIScreen.main.bounds.size.width-30) / 2.0
        //widthConstraint.constant = screenWidth
    }
}
