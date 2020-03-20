//
//  BSTMyYuYueController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/18.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class BSTMyYuYueController: BSTBaseController ,UITableViewDelegate , UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate{

    private let reusedID = "BSTGoodBallCellID"
    var datas : [BSTSquareModel]!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的预约"
        view.addSubview(tableView)
        
        datas = BSTDataManager.shareManager.footballPlaceDatas
        datas?.removeAll(where: { (model: BSTSquareModel) -> Bool in
            return model.appointmenttime == nil
        })
        
        tableView.frame = CGRect(x: 0, y: 0, width: BSTScreenW, height: BSTScreenH - BSTNavigationHeight)
        
        tableView.mj_header = BSTHeader.init(refreshingBlock: { [weak self]  in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self?.tableView.mj_header.endRefreshing()
            })
        })
        tableView.mj_header.beginRefreshing()
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
