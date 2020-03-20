//
//  BSTMyCell.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/18.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTMyCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var subtitleL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = BSTHEXCOLOR(rgbValue:0xe5e5e5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
