//
//  BSTIssueController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import HEPhotoPicker

class BSTIssueController: BSTBaseController ,UICollectionViewDataSource,UICollectionViewDelegate,HEPhotoPickerViewControllerDelegate{
    public var handle : (()->(Void))?
    var selectedModel : [HEPhotoAsset]?
    var selectedImages : [UIImage]?
    let cellID = "PNCChoosePhotoCellID"
    private lazy var textView : YYTextView = {
        let tv = YYTextView.init()
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 5
        tv.layer.borderWidth = 1
        tv.layer.borderColor = BSTThemeCurrentColor.cgColor
        tv.frame = CGRect(x: 15, y: 15, width: BSTScreenW - 30 , height: 150)
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.placeholderText = "请输入您将要写的内容"
        return tv
    }()

    private lazy var collectionView : UICollectionView = {
        let layout =  UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let v = UICollectionView.init(frame: CGRect(x: 15, y: 175, width: 240 + 30, height: 80), collectionViewLayout: layout)
        v.delegate = self
        v.dataSource = self
        v.backgroundColor = UIColor.clear
        v.register(PNCChoosePhotoCell.self, forCellWithReuseIdentifier: cellID)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        view.addSubview(textView)
        view.addSubview(collectionView)
        
        let plus = UIButton()
        plus.setTitle("确定", for: .normal)
        plus.addTarget(self, action: #selector(sureClick as (UIButton) -> ()) , for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView:plus)
    }
    
    
    @objc func sureClick(_:UIButton){
        if self.textView.text.isEmpty {
            YBProgressHUD.showErrorMessage("请输入发布的内容")
            return
        }
        
        if self.selectedImages == nil {
            YBProgressHUD.showErrorMessage("请选择发布的图片")
            return
        }
        YBProgressHUD.showActivityMessage(inWindow: "正在发布")
        
        let issue = Issue()
        issue.startTime = BST_StringFromeDate(date: Date())
        issue.nickname = "方如雪"
        issue.headImage = UIImage(named: "bst_user")!.jpegData(compressionQuality: 0.1)!
        issue.content = self.textView.text!
        
        for image in self.selectedImages! {
            issue.images.append(image.jpegData(compressionQuality: 0.1)!)
        }
        issue.like = 0
        issue.dislike = 0
        BSTDataManager.shareManager.addIssue(issue: issue)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            YBProgressHUD.hide()
            YBProgressHUD.showTipMessage(inWindow: "发布成功")
            if self.handle != nil {
                self.handle!()
            }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.selectedImages != nil else {
            return 1
        }
        let num = self.selectedImages!.count
        if num < 3 {
            return num + 1
        }else{
            return num
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PNCChoosePhotoCell
        cell.deleteBlock = {[weak self] in
            self?.selectedImages?.remove(at: indexPath.row)
            self?.selectedModel?.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        }
        
        if self.selectedImages == nil {
            cell.currentImage = nil
        }else {
            if indexPath.row == self.selectedImages!.count {
                cell.currentImage = nil
            }else {
                cell.currentImage = self.selectedImages![indexPath.row]
            }
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        showActionForPhoto()
    }
    
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage], selectedModel: [HEPhotoAsset]) {
        self.selectedModel = selectedModel
        self.selectedImages = selectedImages
        self.collectionView.reloadData()
    }
    
    func showActionForPhoto(){
        // 配置项
        let option = HEPickerOptions.init()
        option.mediaType = .image
        // 将上次选择的数据传入，表示支持多次累加选择，
        option.defaultSelections = self.selectedModel
        // 选择图片的最大个数
        option.maxCountOfImage = 3
        // 创建选择器
        let picker = HEPhotoPickerViewController.init(delegate: self, options: option)
        // 弹出
        hePresentPhotoPickerController(picker: picker, animated: true)
    }
    
    
}
