//
//  RFFWKWebviewController.swift
//  RFFAccount
//
//  Created by Roddick on 2019/12/12.
//  Copyright © 2019 Roddick. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SnapKit

@objc protocol BSTPolicyDelegate: NSObjectProtocol{
    @objc optional func bst_agreementPolicy()
}

class BSTWKWebviewController: BSTBaseController {
    private var webView : WKWebView!
    private var progress : UIProgressView!
    public var webUrl : String?
    private var agreeBtn , noAgreeBtn : UIButton!
    private let networkManager = NetworkReachabilityManager()
    weak var delegate: BSTPolicyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "隐私政策"
        webView = WKWebView.init(frame: self.view.bounds)
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-35-BSTBottomSafeAreaHeight)
        }
        progress = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 1.5))
        progress.progressTintColor = BSTThemeCurrentColor
        progress.trackTintColor = UIColor.clear
        self.view.addSubview(progress)
        if webUrl == nil {
            webUrl = BSTAgreementUrl
        }
        let request = URLRequest(url: URL(string: webUrl!)!)
        webView.load(request)
        networkManager?.startListening(onUpdatePerforming: { (statue) in
            switch statue{
                case .notReachable://// "无法连接网络"
                    YBProgressHUD.showErrorMessage("无法连接网络,请检查...")
                case .unknown:// "未知网络"
                    fallthrough
                case .reachable(.cellular):// "蜂窝移动网络"
                    fallthrough
                case .reachable(.ethernetOrWiFi):////"WIFI-网络"
                    guard self.webView.url == nil else {
                        self.webView.load(URLRequest(url: self.webView.url!))
                        return ;
                    }
                    self.webView.load(request)
            }
        })
        
        agreeBtn = UIButton.init()
        view.addSubview(agreeBtn)
        agreeBtn.layer.masksToBounds = true
        agreeBtn.layer.cornerRadius = 25/2
        agreeBtn.setBackgroundImage(BSTGetImageWithColor(color: BSTThemeCurrentColor), for: UIControl.State.normal)
        agreeBtn.setBackgroundImage(BSTGetImageWithColor(color: BSTThemeCurrentColor), for: UIControl.State.selected)
        agreeBtn.setTitle("同意", for: UIControl.State.normal)
        agreeBtn.setTitle("同意", for: UIControl.State.selected)
        agreeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        agreeBtn.addTarget(self, action: #selector(agreeClick), for: UIControl.Event.touchUpInside)
        agreeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.equalTo(120)
            make.height.equalTo(25)
            make.bottom.equalTo(-BSTBottomSafeAreaHeight-5)
        }
        
        noAgreeBtn = UIButton.init()
        view.addSubview(noAgreeBtn)
        noAgreeBtn.layer.masksToBounds = true
        noAgreeBtn.layer.cornerRadius = 25/2
        noAgreeBtn.setBackgroundImage(BSTGetImageWithColor(color: UIColor.lightGray), for: UIControl.State.normal)
        noAgreeBtn.setBackgroundImage(BSTGetImageWithColor(color: UIColor.lightGray), for: UIControl.State.selected)
        noAgreeBtn.setTitle("不同意", for: UIControl.State.normal)
        noAgreeBtn.setTitle("不同意", for: UIControl.State.selected)
        noAgreeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        noAgreeBtn.addTarget(self, action: #selector(noAgreeClick), for: UIControl.Event.touchUpInside)
        noAgreeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.width.equalTo(120)
            make.height.equalTo(25)
            make.bottom.equalTo(-BSTBottomSafeAreaHeight-5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func agreeClick() -> (Void) {
        UserDefaults.standard.set("BSTPolicyST", forKey: BSTPolicyST)
        self.delegate?.bst_agreementPolicy?()
    }
    
    @objc func noAgreeClick() -> (Void) {
        YBProgressHUD.showErrorMessage("请先同意隐私政策才能更好的体验我们的App!")
    }
}
