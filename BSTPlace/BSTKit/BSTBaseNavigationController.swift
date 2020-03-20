//
//  BSTBaseNavigationController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.setBackgroundImage(BSTGetImageWithColor(color: BSTThemeCurrentColor), for: UIBarMetrics.default)
        navigationBarAppearance.shadowImage = UIImage.init()
        navigationBarAppearance.tintColor = UIColor.lightGray
        let textAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBarAppearance.titleTextAttributes = textAttributes
        
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        navigationBar.layer.shadowOpacity = 0.2
        navigationBar.layer.shadowRadius = 2.0
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if(viewControllers.count > 0){
            let btn : UIButton = UIButton.init(type: UIButton.ButtonType.custom)
            btn.setImage(UIImage.init(named: "bst_bar_back_1"), for: UIControl.State.normal)
            btn.sizeToFit()
            btn.frame.size = CGSize(width: 30, height: 40)
            btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            btn.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if (viewControllers.count == 0) {
            tabBarController?.tabBar.isHidden = false;
        }
        return super.popViewController(animated: animated)
    }
    
    @objc func goBack()->Void{
       _ = popViewController(animated: true)
    }


}
