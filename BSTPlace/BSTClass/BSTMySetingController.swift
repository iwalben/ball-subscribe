//
//  BSTMySetingController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/18.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

let infoDic = Bundle.main.infoDictionary!
// 获取 App 的版本号
let bst_appVersion = infoDic["CFBundleShortVersionString"]
// 获取 App 的 build 版本
let bst_appBuildVersion = infoDic["CFBundleVersion"]
// 获取 App 的名称
let bst_appName = infoDic["CFBundleDisplayName"]

class BSTMySetingController: BSTBaseController,UITableViewDelegate , UITableViewDataSource {
    private let reusedID = "SettingCellID"
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = BSTHEXCOLOR(rgbValue:0xe5e5e5)
        tView.rowHeight = 80
        tView.register(UINib(nibName: "BSTMyCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    
    let titles = ["清除缓存","分享","隐私政策","当前版本","退出登录"]
    let imagees = ["resume_detail_2","resume_detail_6","resume_detail_4","resume_detail_3","resume_detail_7"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: BSTScreenW, height: BSTScreenH - BSTTabBarHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! BSTMyCell
        cell.titleL.text = titles[indexPath.row]
        cell.subtitleL.text = ""
        cell.imageV.image = UIImage(named: imagees[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("print(indexPath.row)")
        print(indexPath.row)
        
        switch indexPath.row {
        case 0:
            YBProgressHUD.showActivityMessage(inWindow: "正在清理缓存")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                YBProgressHUD.hide()
                YBProgressHUD.showTipMessage(inWindow: "已清理2.5M")
            })
        case 1:
            let activityItemsArray = [BSTAppFullName]
            let activityVC = UIActivityViewController.init(activityItems: activityItemsArray, applicationActivities: nil)
            activityVC.isModalInPopover = true
            let itemsBlock : UIActivityViewController.CompletionWithItemsHandler = {(activityType: UIActivity.ActivityType? ,completed : Bool ,returnedItems: [Any]? , activityError:Error? )in
                if completed {
                    print("completed")
                }else{
                    print("cancel")
                }
            }
            activityVC.completionWithItemsHandler = itemsBlock
            self.present(activityVC, animated: true, completion: nil)
        case 2:
            self.navigationController?.pushViewController(BSTPriveController(), animated: true)
        case 3:
            YBProgressHUD.showTipMessage(inWindow: "当前版本号v\(String(describing: bst_appVersion))")
        case 4:
            UserDefaults.standard.set(nil, forKey: BSTLoginSuccess)
            YBProgressHUD.showActivityMessage(inWindow: "正在退出")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                YBProgressHUD.hide()
                UIApplication.shared.keyWindow?.rootViewController = BSTBaseTabBarController.getIndexTabBarControllerData(index: 0)
            })
        default:
            return
        }
    }
}
