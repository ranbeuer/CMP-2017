//
//  EventProgramCell.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/31/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit

class EventProgramCell : UICollectionViewCell {
    @IBOutlet var backgroundImageView : UIImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var descriptionLabel : UILabel?
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var bookmarkImageView : UIImageView?
    @IBOutlet var likesLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
