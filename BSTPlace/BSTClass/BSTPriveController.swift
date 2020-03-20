//
//  BSTPriveController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/18.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import WebKit

class BSTPriveController: BSTBaseController {

    private var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "隐私政策"
        webView = WKWebView.init(frame: self.view.bounds)
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-BSTBottomSafeAreaHeight)
        }
        webView.load(URLRequest(url: URL(string: BSTPrivateUrl)!))
    }
}
