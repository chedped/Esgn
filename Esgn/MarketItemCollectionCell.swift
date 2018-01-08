//
//  MarketItemCollectionCell.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/15/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import Cosmos

class MarketItemCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var imgGame: UIImageView!
}
