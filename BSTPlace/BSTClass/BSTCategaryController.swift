//
//  BSTCategaryController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import SnapKit
import JXBanner
import JXPageControl

class BSTCategaryController: BSTBaseController,JXBannerDelegate,JXBannerDataSource {
    let images = ["q4","q5"]
    let titles = ["篮球场","足球场"]
    var pageCount = 2

    lazy var converflowBanner: JXBanner = {
        let banner = JXBanner()
        banner.placeholderImgView.image = UIImage(named: "banner_placeholder")
        banner.backgroundColor = UIColor.clear
        banner.indentify = "converflowBanner"
        banner.delegate = self
        banner.dataSource = self
        return banner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(converflowBanner)
        converflowBanner.snp.makeConstraints {(maker) in
            maker.left.right.equalTo(view)
            maker.top.equalTo(50)
            maker.bottom.equalTo(view.snp_bottom).offset(-50)
        }
        self.automaticallyAdjustsScrollViewInsets = false
    }

    deinit {
        print("\(#function) ----------> \(#file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? #file)")
    }
    
    //MARK: - JXBannerDelegate
    // 点击cell回调
    public func jxBanner(_ banner: JXBannerType,
        didSelectItemAt index: Int) {
        print(index)
        
        if index == 0 {
            let vc = BSTSquareListController()
            vc.mainTitle = "篮球场地"
            vc.datas = Array((BSTDataManager.shareManager.footballPlaceDatas![24..<39]))
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (index == 1){
            let vc = BSTSquareListController()
            vc.mainTitle = "足球场地"
            vc.datas = Array((BSTDataManager.shareManager.footballPlaceDatas![0..<24]))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // 最中心显示cell 索引
    func jxBanner(_ banner: JXBannerType, center index: Int) {
        //print(index)
    }
    
    //MARK:- JXBannerDataSource
    // 注册重用Cell标识
        func jxBanner(_ banner: JXBannerType)
            -> (JXBannerCellRegister) {

            return JXBannerCellRegister(type: JXBannerCell.self,
            reuseIdentifier: "ConverflowBannerCell")
        }

        // 轮播总数
        func jxBanner(numberOfItems banner: JXBannerType)
            -> Int { return pageCount }

        // 轮播cell内容设置
        func jxBanner(_ banner: JXBannerType,
            cellForItemAt index: Int,
            cell: UICollectionViewCell)
            -> UICollectionViewCell {
                let tempCell: JXBannerCell = cell as! JXBannerCell
                tempCell.layer.cornerRadius = 8
                tempCell.layer.masksToBounds = true
                tempCell.imageView.image = UIImage(named: images[index])
                tempCell.msgLabel.text = titles[index]
                return tempCell
        }

        // banner基本设置（可选）
        func jxBanner(_ banner: JXBannerType,
            params: JXBannerParams)
            -> JXBannerParams {

            return params
            .timeInterval(3)
            .cycleWay(.forward)
            .isShowPageControl(false)
            .isAutoPlay(false)
        }

    // banner布局、动画设置
        func jxBanner(_ banner: JXBannerType,
            layoutParams: JXBannerLayoutParams)
            -> JXBannerLayoutParams {

            return layoutParams
            .layoutType(JXBannerTransformCoverflow())
            .itemSize(CGSize(width: BSTScreenW-100, height: BSTScreenH-BSTNavigationHeight-BSTTabBarHeight-100))
            .itemSpacing(0)
            .maximumAngle(0.25)
            .rateHorisonMargin(0.3)
            .minimumAlpha(0.8)
        }
}


