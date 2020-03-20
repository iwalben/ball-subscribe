//
//  BSTSubscribeController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class BSTSubscribeController: BSTBaseController ,UITableViewDelegate , UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate{
    var pageView : BSTHeadPageView!
    private let reusedID = "BSTGoodBallCellID"
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = UIColor.white
        tView.rowHeight = 200
        tView.register(UINib(nibName: "BSTSubscribeCell", bundle: .main), forCellReuseIdentifier: reusedID)
        tView.emptyDataSetSource = self
        tView.emptyDataSetDelegate = self
        return tView
    }()
    var datas : [BSTSquareModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "预约"
        pageView = BSTHeadPageView.init(frame: CGRect(x: 0, y: 0, width: BSTScreenW, height: 40), items: ["已预约","已取消","已完成"])
        view.addSubview(pageView)
        view.addSubview(tableView)
        pageView.currentIndexBlock = {[weak self] (index: Int)-> (Void) in
            self?.tableView.mj_header.beginRefreshing()
            if index == 101 {
                self!.datas = BSTDataManager.shareManager.footballPlaceDatas
                self!.datas?.removeAll(where: { (model: BSTSquareModel) -> Bool in
                    return !((model.appointmenttime != nil)&&(model.cancle == true)&&(model.finished == false))
                })
            }else if (index == 102){
                self!.datas = BSTDataManager.shareManager.footballPlaceDatas
                self!.datas?.removeAll(where: { (model: BSTSquareModel) -> Bool in
                    return !((model.appointmenttime != nil)&&(model.cancle == false)&&(model.finished == true))
                })
            }else{
                self!.datas = BSTDataManager.shareManager.footballPlaceDatas
                self!.datas?.removeAll(where: { (model: BSTSquareModel) -> Bool in
                    return model.appointmenttime == nil
                })
            }
            self?.tableView.reloadData()
        }
        
        tableView.frame = CGRect(x: 0, y: 40, width: BSTScreenW, height: BSTScreenH - 40 - BSTNavigationHeight - BSTTabBarHeight)
        tableView.mj_header = BSTHeader.init(refreshingBlock: { [weak self]  in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self?.tableView.mj_header.endRefreshing()
            })
        })
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datas = BSTDataManager.shareManager.footballPlaceDatas
        datas?.removeAll(where: { (model: BSTSquareModel) -> Bool in
            return model.appointmenttime == nil
        })
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard datas != nil else {
            return 0
        }
        return datas!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! BSTSubscribeCell
        guard datas != nil else {
            return cell
        }
        cell.model = datas![indexPath.row]
        cell.finishHandle = { (model:BSTSquareModel) in
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    //MARK: EmptyDataSetSource
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?{
        return UIImage(named:"ic_empty_nocontent")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?{
        let attr = NSAttributedString.init(string: "暂无数据", attributes: [NSAttributedString.Key.foregroundColor:BSTThemeCurrentColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
        return attr
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

}
