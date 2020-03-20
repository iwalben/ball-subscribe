//
//  AppDelegate.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,BSTPolicyDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //数据库配置
        BSTDataManager.shareManager.configuralRealm()
        //数据配置
        let jsonString = BST_GetConfiguration(resource: "BSTHomeData")
        BSTDataManager.shareManager.footballPlaceDatas = ([BSTSquareModel].deserialize(from: jsonString) as! [BSTSquareModel])
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        BST_LoadDatas()
        
        let ap = UserDefaults.standard.object(forKey: BSTPolicyST)
        guard ap == nil  else {
            window?.rootViewController = BSTBaseTabBarController.getIndexTabBarControllerData(index: 0)
            return true
        }
        let policy = BSTWKWebviewController.init()
        policy.delegate = self
        let nav:BSTBaseNavigationController = BSTBaseNavigationController.init(rootViewController:policy)
        window?.rootViewController = nav
        return true
    }
    
    func bst_agreementPolicy(){
        window?.rootViewController = BSTBaseTabBarController.getIndexTabBarControllerData(index: 0)
    }
    
}

