//
//  BSTMyController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTMyController: BSTBaseController ,UITableViewDelegate , UITableViewDataSource{
    private let reusedID = "BSTMyCellID"
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = BSTHEXCOLOR(rgbValue:0xe5e5e5)
        tView.rowHeight = 80
        tView.tableHeaderView = headerVirew
        tView.register(UINib(nibName: "BSTMyCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    
    let datas = ["我的发布","我的收藏","我的预约"]
    let imagees = ["resume_detail_1","resume_detail_5","resume_detail_9"]
    
    let headerVirew : BSTMyHeaderView = {
        let nibs = Bundle.main.loadNibNamed("BSTMyHeaderView", owner: nil, options:nil)
        return (nibs?.first as! BSTMyHeaderView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerVirew.isUserInteractionEnabled = true
        headerVirew.jk_addTapAction {[weak self] (_ :UIGestureRecognizer?) in
            self?.navigationController?.pushViewController(BSTMySetingController(), animated: true)
        }
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: -BSTStatusBarHeight, width: BSTScreenW, height: BSTScreenH - BSTTabBarHeight+BSTStatusBarHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! BSTMyCell
        cell.titleL.text = datas[indexPath.row]
        cell.imageV.image = UIImage(named: imagees[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(BSTMyFaBuController(), animated: true)
        case 1:
            navigationController?.pushViewController(BSTMyShouCangController(), animated: true)
        case 2:
            navigationController?.pushViewController(BSTMyYuYueController(), animated: true)
        default:
            return
        }
    }
}
