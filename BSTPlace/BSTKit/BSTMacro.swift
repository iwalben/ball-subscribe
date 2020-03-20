//
//  BSTMacro.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

//字体黑色
let BSTFontBlack = BSTHEXCOLOR(rgbValue:0x232000)


let BSTPrivateUrl = "https://www.baidu.com"
let BSTAgreementUrl = "https://www.baidu.com"
let BSTAppFullName = "xx-app"

let BSTReamlKey = "BSTReamlKey"
let BSTLoginSuccess = "BSTLoginSuccess"
let BSTPolicyST = "BSTPolicyst"


//状态栏高度
let BSTStatusBarHeight =  UIApplication.shared.statusBarFrame.size.height

//导航栏高度
let BSTNavigationHeight = (BSTStatusBarHeight + 44)
//tabbar高度
let BSTTabBarHeight =  (CGFloat)(BSTStatusBarHeight == 44 ? 83 : 49)
//顶部的安全距离
let BSTTopSafeAreaHeight = (BSTStatusBarHeight - 20)
//底部的安全距离
let BSTBottomSafeAreaHeight = (BSTTabBarHeight - 49)
//屏幕宽度
let BSTScreenW = UIScreen.main.bounds.size.width
//屏幕高度
let BSTScreenH = UIScreen.main.bounds.size.height

//主颜色
let BSTThemeCurrentColor = BSTHEXCOLOR(rgbValue:0x95C060)

//灰
let BSTDarkColor = BSTHEXCOLOR(rgbValue:0xE7E7E7)

//16进制转换
func BSTHEXCOLOR(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//RGB转换
func BSTRGBCOLOR(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
   return UIColor(red:  r/255.0, green: g/255.0, blue:  b/255.0, alpha: 1)
}

//系统版本号
let BSTSystemVersion =  (UIDevice.current.systemVersion as NSString).floatValue

//默认适配宽度
func BSTAutoWidthScale(value: CGFloat) -> CGFloat {
    return (CGFloat.init(BSTScreenW) / 360.0) * value
}

/// 将颜色转换为图片
///
/// - Parameter color: UIColor
/// - Returns: UIImage
func BSTGetImageWithColor(color:UIColor)->UIImage{
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}


func BST_GetConfiguration(resource: String) -> String? {
    if let path = Bundle.main.path(forResource: resource, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            //let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            //return jsonResult
            let jsonString = String(data: data, encoding: String.Encoding.utf8)
            return jsonString
        } catch {
            // maybe lets throw error here
            return nil
        }
    }
    return nil
}

func BST_StringFromeDate(date:Date) -> String {
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.string(from: date as Date)
}

func BST_LoadDatas(){
    if  UserDefaults.standard.object(forKey: BSTReamlKey) == nil {
        let issue0 = Issue()
        issue0.startTime = "2020-03-18"
        issue0.nickname = "倔强的篮球"
        issue0.headImage = UIImage(named: "bst_person0")!.jpegData(compressionQuality: 0.01)!
        issue0.content = "篮球迷都在哪啊？"
        issue0.images.append(UIImage(named: "bst_forum_team0")!.jpegData(compressionQuality: 0.01)!)
        issue0.images.append(UIImage(named: "bst_forum_team1")!.jpegData(compressionQuality: 0.01)!)
        issue0.images.append(UIImage(named: "bst_forum_team3")!.jpegData(compressionQuality: 0.01)!)
        issue0.like = 20
        issue0.dislike = 3
        BSTDataManager.shareManager.addIssue(issue: issue0)
        
        let issue1 = Issue()
        issue1.startTime = "2020-03-18"
        issue1.nickname = "你的背包"
        issue1.headImage = UIImage(named: "bst_person1")!.jpegData(compressionQuality: 0.01)!
        issue1.content = "周六来一起去打球啊！"
        issue1.images.append(UIImage(named: "bst_forum_team4")!.jpegData(compressionQuality: 0.01)!)
        issue1.like = 8
        issue1.dislike = 1
        BSTDataManager.shareManager.addIssue(issue: issue1)
        
        let issue2 = Issue()
        issue2.startTime = "2020-03-18"
        issue2.nickname = "宏磊"
        issue2.headImage = UIImage(named: "bst_person2")!.jpegData(compressionQuality: 0.01)!
        issue2.content = "这个室内球场不错哦！"
        issue2.images.append(UIImage(named: "bst_forum_team5")!.jpegData(compressionQuality: 0.01)!)
        issue2.images.append(UIImage(named: "bst_forum_team6")!.jpegData(compressionQuality: 0.01)!)
        issue2.like = 5
        issue2.dislike = 0
        BSTDataManager.shareManager.addIssue(issue: issue2)
        
        UserDefaults.standard.set("realm_load", forKey: BSTReamlKey)
    }
}

