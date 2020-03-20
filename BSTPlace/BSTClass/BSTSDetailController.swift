//
//  BSTSDetailController.swift
//  CFBall
//
//  Created by Roddick on 2020/3/3.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTSDetailController: BSTBaseController {
    //var model : CFBFieldModel?
    
    @IBOutlet weak var bigImageV: UIImageView!
    @IBOutlet weak var littleImageV: UIImageView!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var introduce: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var model : BSTSquareModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plus = UIButton()
        plus.setTitle("收藏", for: .normal)
        plus.addTarget(self, action: #selector(collectClick as (UIButton) -> ()) , for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView:plus)
    
        guard  model != nil else { return }
        self.title = model?.placeName
        bigImageV.image = UIImage(named: model!.imageName!)
        fieldName.text = model?.placeName
        score.text =  "评分:  " + model!.grade!
        price.text = "¥ " + model!.price! + "/小时"
        introduce.text = model!.introduce!
        openTime.text = model!.opentime!
        telephone.text = model!.phoneNum
        address.text = model!.address
    }
    
    @objc func collectClick(_ sender:Any){
        let ap = UserDefaults.standard.object(forKey: BSTLoginSuccess)
        if ap == nil {
            if #available(iOS 11.0, *) {
                let addVC: LoginViewController = LoginViewController.init()
                let addNavC: BSTBaseNavigationController = BSTBaseNavigationController.init(rootViewController: addVC)
                addNavC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(addNavC, animated: false, completion: {})
            } else {
                // Fallback on earlier versions
            }
            return
        }
        YBProgressHUD.showSuccessMessage("收藏成功")
    }
    
    @IBAction func appointmentClick(_ sender: Any) {
        let ap = UserDefaults.standard.object(forKey: BSTLoginSuccess)
        if ap == nil {
            if #available(iOS 11.0, *) {
                let addVC: LoginViewController = LoginViewController.init()
                let addNavC: BSTBaseNavigationController = BSTBaseNavigationController.init(rootViewController: addVC)
                addNavC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(addNavC, animated: false, completion: {})
            } else {
                // Fallback on earlier versions
            }
            return
        }
        let pickerV = BRDatePickerView.init(pickerMode:.MDHM)
        pickerV.resultBlock = {[weak self](selectDate:Date? , selectValue:String?)->(Void)in
            print(selectValue ?? "")
            self!.model?.appointmenttime = selectValue
            let vc = BSTSquareSureController()
            vc.model = self?.model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        pickerV.title = "请选择"
        pickerV.show()
    }
}
