//
//  BSTBaseTabBarController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTBaseTabBarController: UITabBarController ,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabbarsub : UITabBar = UITabBar.appearance()
        tabbarsub.backgroundImage = BSTGetImageWithColor(color: UIColor.white)
        tabbarsub.shadowImage = UIImage.init()
        
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        self.tabBar.layer.shadowOpacity = 0.2
        self.tabBar.layer.shadowRadius = 2.0
        delegate = self
    }
    
    func addChildViewController(childViewController:UIViewController ,title:String , imageName:String ,selecedImageName:String) -> Void {
        childViewController.title = title
        childViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:BSTThemeCurrentColor], for: UIControl.State.selected)
        childViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.normal)
        childViewController.tabBarItem.selectedImage = UIImage.init(named: selecedImageName)
        childViewController.tabBarItem.image = UIImage.init(named: imageName)
        
        let nav:BSTBaseNavigationController = BSTBaseNavigationController.init(rootViewController: childViewController)
        nav.navigationBar.isHidden = true
        self.addChild(nav)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let nac : BSTBaseNavigationController = viewController as! BSTBaseNavigationController
        let vc = nac.viewControllers.first
        if vc?.title == "我的" || vc?.title == "预约" {
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
                return false
            }
        }
        return true
    }
    
    static func getIndexTabBarControllerData(index:Int) -> (BSTBaseTabBarController) {
        let tabbarVc:BSTBaseTabBarController = BSTBaseTabBarController.init()
        tabbarVc.addChildViewController(childViewController: BSTSquareController.init(), title: "广场", imageName: "", selecedImageName: "明细球场")
        tabbarVc.addChildViewController(childViewController: BSTCategaryController.init(), title: "分类", imageName: "排名", selecedImageName: "排名（默认）")
        tabbarVc.addChildViewController(childViewController: BSTCommunityController.init(), title: "社区", imageName: "icon_fabu1", selecedImageName: "icon_fabu2")
        tabbarVc.addChildViewController(childViewController: BSTSubscribeController.init(), title: "预约", imageName: "duiwu", selecedImageName: "duiwuxuan")
        tabbarVc.addChildViewController(childViewController: BSTMyController.init(), title: "我的", imageName: "更多", selecedImageName: "更多（默认）")
        tabbarVc.selectedIndex = index
        return tabbarVc
    }
}
