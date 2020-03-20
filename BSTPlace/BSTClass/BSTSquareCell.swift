//
//  BSTSquareCell.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTSquareCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    var _model: BSTSquareModel?
    var model: BSTSquareModel?{
        set{
            _model = newValue
            imageV.image = UIImage(named: _model?.imageName ?? "")
            label1.text = _model?.placeName ?? ""
            label2.text = "地址: " + (_model?.address ?? "")
            label3.text = "评分: " + (_model?.grade ?? "")
            label4.text = "¥ " + (_model?.price ?? "") + "/小时"
        }
        get{
            return _model
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
