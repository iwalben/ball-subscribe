//
//  BSTSquareController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTSquareController: BSTBaseController ,UITableViewDelegate , UITableViewDataSource{
    let headerVirew : BSTSquareHeaderView = {
        let nibs = Bundle.main.loadNibNamed("BSTSquareHeaderView", owner: nil, options:nil)
        return (nibs?.first as! BSTSquareHeaderView)
    }()
    var datas : [BSTSquareModel]!
    
    private let reusedID = "BSTSquareCellID"
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = UIColor.white
        tView.rowHeight = 110
        tView.tableHeaderView = headerVirew
        tView.register(UINib(nibName: "BSTSquareCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerVirew.leftV.isUserInteractionEnabled = true
        headerVirew.rightV.isUserInteractionEnabled = true
        
        headerVirew.leftV.jk_addTapAction {[weak self] (_ :UIGestureRecognizer?) in
            let vc = BSTSquareListController()
            vc.mainTitle = "最新场地"
            let temp = BSTDataManager.shareManager.footballPlaceDatas
            vc.datas = temp?.sorted(by: { (m1 : BSTSquareModel, m2 : BSTSquareModel) -> Bool in
                let a : Double = Double(m1.price!)!
                let b : Double = Double(m2.price!)!
                return a > b
            })
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        headerVirew.rightV.jk_addTapAction { [weak self](_:UIGestureRecognizer?) in
            let vc = BSTSquareListController()
            vc.mainTitle = "最热场地"
            let temp = BSTDataManager.shareManager.footballPlaceDatas
            vc.datas = temp?.sorted(by: { (m1 : BSTSquareModel, m2 : BSTSquareModel) -> Bool in
                let a : Double = Double(m1.grade!)!
                let b : Double = Double(m2.grade!)!
                return a > b
            })
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        datas = requestDatas()
        
        
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: BSTScreenW, height: BSTScreenH - BSTNavigationHeight - BSTTabBarHeight)

        tableView.mj_header = BSTHeader.init(refreshingBlock: { [weak self]  in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self?.tableView.mj_header.endRefreshing()
                self!.datas = self!.requestDatas()
                self?.tableView.reloadData()
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
        let randomIndex = 8
        while randomSet.count < randomIndex {
            let i = Int(arc4random()  % 38)
            randomSet.add(array![i])
        }
        return (randomSet.allObjects as! [BSTSquareModel])
    }
}
