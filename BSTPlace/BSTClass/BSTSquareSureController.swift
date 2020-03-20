//
//  BSTSquareSureController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/13.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTSquareSureController: BSTBaseController {

    @IBOutlet weak var addressL: UILabel!
    @IBOutlet weak var photoNumL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var placeNameL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var gradeL: UILabel!
    
    var model : BSTSquareModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提交预约"
        
        
        guard model != nil else {
            return
        }
        
        self.addressL.text = "预约地址: " + model!.address!
        self.photoNumL.text = "联系方式: " + model!.phoneNum!
        self.timeL.text = "预约时间: " + model!.appointmenttime!

        self.imageV.image = UIImage(named: model!.imageName!)
        self.placeNameL.text = model?.placeName
        self.priceL.text = "¥ " + model!.price! + "/小时"
        self.gradeL.text = "评分: " + model!.grade!

    }

    @IBAction func sureClick(_ sender: Any) {
        YBProgressHUD.showActivityMessage(inWindow: "正在预约")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
            YBProgressHUD.hide()
            YBProgressHUD.showSuccessMessage("预约成功")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                UIApplication.shared.keyWindow?.rootViewController = BSTBaseTabBarController.getIndexTabBarControllerData(index: 3)
            })
        })
    }
}
