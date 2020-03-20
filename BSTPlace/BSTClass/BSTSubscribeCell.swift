//
//  BSTSubscribeCell.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/13.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTSubscribeCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var placeNameL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var placeL: UILabel!
    @IBOutlet weak var photoNumL: UILabel!
    @IBOutlet weak var openTimeL: UILabel!
    
    @IBOutlet weak var finishBtn: UIButton!
    
    @IBOutlet weak var cancleBtn: UIButton!
    
    
    
    var canleHandle : ((_ m: BSTSquareModel)->Void)?
    var finishHandle : ((_ m: BSTSquareModel)->Void)?
    var _model: BSTSquareModel?
    var model: BSTSquareModel?{
        set{
            _model = newValue
            guard _model != nil else {
                return
            }
            imageV.image = UIImage(named: _model?.imageName ?? "")
            placeNameL.text = _model?.placeName
            priceL.text = "¥ " + _model!.price! + "/小时"
            placeL.text = "场馆地址: " + _model!.address!
            photoNumL.text = "联系电话: " + _model!.phoneNum!
            openTimeL.text = "预约时间: " + (_model!.appointmenttime ?? "")
            finishBtn.isHidden = _model!.finished||_model!.cancle
            cancleBtn.isHidden = _model!.finished||_model!.cancle
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
    
    @IBAction func finishClick(_ sender: Any) {
        finishBtn.isHidden = true
        cancleBtn.isHidden = true
        self.model?.finished = true
        guard self.finishHandle != nil else {
            return
        }
        self.finishHandle!(self.model!)
    }
    @IBAction func cancleClick(_ sender: Any) {
        finishBtn.isHidden = true
        cancleBtn.isHidden = true
        self.model?.cancle = true
        guard self.finishHandle != nil else {
            return
        }
        self.finishHandle!(self.model!)
    }
    
    
    
    
    
    
    
}
