//
//  BSTCommunityCell.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTCommunityCell: UITableViewCell {
    @IBOutlet weak var headerImageV: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var V1: UIImageView!
    @IBOutlet weak var V2: UIImageView!
    @IBOutlet weak var V3: UIImageView!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var zanL: UILabel!
    @IBOutlet weak var caiL: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dislikeBtn: UIButton!
    
    var shareHandle : ((Issue)->(Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func zanClick(_ sender: Any) {
        if self.model?.like != Int(self.zanL.text!)!{
            YBProgressHUD.showErrorMessage("您已经点过赞了")
            return
        }
        self.zanL.text = String(Int(self.zanL.text!)! + 1)
        self.likeBtn.setImage(UIImage(named: "ico_dianzan"), for: .normal)
    }
    
    @IBAction func caiClick(_ sender: Any) {
        if self.model?.dislike != Int(self.caiL.text!)!{
            YBProgressHUD.showErrorMessage("您已经点过踩了")
            return
        }
        self.caiL.text = String(Int(self.caiL.text!)! + 1)
        self.dislikeBtn.setImage(UIImage(named: "ico_diancai"), for: .normal)
    }
    
    var _model: Issue?
    var model: Issue?{
        set{
            _model = newValue
            self.contentL.text = _model?.content
            self.nickName.text = _model?.nickname
            self.headerImageV.image =  UIImage(data: _model!.headImage)
            switch _model?.images.count {
                case 1:
                    let decoder = YYImageDecoder(data: (_model?.images[0])!, scale:1.0)
                    V1.image = decoder?.frame(at: 0, decodeForDisplay: true)?.image
                case 2:
                    let decoder = YYImageDecoder(data: (_model?.images[0])!, scale:1.0)
                    V1.image = decoder?.frame(at: 0, decodeForDisplay: true)?.image
                    let decoder2 = YYImageDecoder(data: (_model?.images[1])!, scale:1.0)
                    V2.image = decoder2?.frame(at: 0, decodeForDisplay: true)?.image
                case 3:
                    let decoder = YYImageDecoder(data: (_model?.images[0])!, scale:1.0)
                    V1.image = decoder?.frame(at: 0, decodeForDisplay: true)?.image
                    let decoder2 = YYImageDecoder(data: (_model?.images[1])!, scale:1.0)
                    V2.image = decoder2?.frame(at: 0, decodeForDisplay: true)?.image
                    let decoder3 = YYImageDecoder(data: (_model?.images[2])!, scale:1.0)
                    V3.image = decoder3?.frame(at: 0, decodeForDisplay: true)?.image
//                    V1.image = UIImage(data: (_model?.images[0])!)
//                    V2.image = UIImage(data: (_model?.images[1])!)
//                    V3.image = UIImage(data: (_model?.images[2])!)
                default:
                    V1.image = UIImage.init()
            }
            self.timeL.text = _model?.startTime
            self.zanL.text = String(_model!.like)
            self.caiL.text = String(_model!.dislike)
            
            
            if self.model?.like != Int(self.zanL.text!)!{
                self.likeBtn.setImage(UIImage(named: "ico_dianzan"), for: .normal)
            }else{
                self.likeBtn.setImage(UIImage(named: "dianzan-1"), for: .normal)
            }
            
            
            if self.model?.dislike != Int(self.caiL.text!)!{
                self.dislikeBtn.setImage(UIImage(named: "ico_diancai"), for: .normal)
            }else{
                self.dislikeBtn.setImage(UIImage(named: "diancai"), for: .normal)
            }
        }
        get{
            return _model
        }
    }
    @IBAction func shareClick(_ sender: Any) {
        guard self.shareHandle != nil else {return}
        self.shareHandle!(self.model!)
    }
}
