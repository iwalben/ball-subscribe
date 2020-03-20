//
//  BSTMyShouCangController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/18.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTMyShouCangController: BSTBaseController ,UITableViewDelegate , UITableViewDataSource{
    var datas : [BSTSquareModel]!
    private let reusedID = "BSTSquareCellID"
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = UIColor.white
        tView.rowHeight = 110
        tView.register(UINib(nibName: "BSTSquareCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        datas = requestDatas()
        
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: BSTScreenW, height: BSTScreenH - BSTNavigationHeight)

        tableView.mj_header = BSTHeader.init(refreshingBlock: { [weak self]  in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self?.tableView.mj_header.endRefreshing()
            })
        })
        tableView.mj_header.beginRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! BSTSquareCell
        cell.model = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BSTSDetailController()
        vc.model = self.datas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestDatas() -> [BSTSquareModel]! {
        let array = BSTDataManager.shareManager.footballPlaceDatas
        let randomSet  = NSMutableSet.init()
        var randomIndex =  Int(arc4random()  % 38)
        if randomIndex <= 5 {
            randomIndex = 5
        }
        
        if randomIndex >= 10 {
            randomIndex = 10
        }
        while randomSet.count < randomIndex {
            let i = Int(arc4random()  % 38)
            randomSet.add(array![i])
        }
        return (randomSet.allObjects as! [BSTSquareModel])
    }
}
