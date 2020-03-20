//
//  BSTSquareListController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/16.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTSquareListController: BSTBaseController ,UITableViewDelegate , UITableViewDataSource{
    var datas : [BSTSquareModel]!
    private let reusedID = "BSTListCellID"
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
    
    var mainTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = mainTitle
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
        return datas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! BSTSquareCell
        cell.model = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BSTSDetailController()
        vc.model = self.datas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
