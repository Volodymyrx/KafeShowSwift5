//
//  CafeTableViewCell.swift
//  KafeShowSwift5
//
//  Created by v on 03.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import UIKit
import Cosmos

class CafeTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView! {
        didSet{
            
            imageCell.layer.cornerRadius = imageCell.frame.size.height / 2
            imageCell.clipsToBounds = true
        }
    }
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
    
    
    
    
    
    
    

}
