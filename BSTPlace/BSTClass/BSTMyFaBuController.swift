//
//  BSTMyFaBuController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/18.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import RealmSwift

class BSTMyFaBuController: BSTBaseController ,UITableViewDelegate , UITableViewDataSource{

    var issues : Results<Issue>!
    
    private let reusedID = "BSTCommunityCellID"
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = UIColor.white
        tView.rowHeight = UITableView.automaticDimension
        tView.estimatedRowHeight = 327
        tView.register(UINib(nibName: "BSTCommunityCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的发布"
        
        issues = BSTDataManager.shareManager.queryIssue(nickname: "方如雪")
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
        return issues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! BSTCommunityCell
        cell.model = issues[indexPath.row]
        cell.shareHandle = {[weak self](issue : Issue) in
            let activityItemsArray = [issue.content]
            let activityVC = UIActivityViewController.init(activityItems: activityItemsArray, applicationActivities: nil)
            activityVC.isModalInPopover = true
            let itemsBlock : UIActivityViewController.CompletionWithItemsHandler = {(activityType: UIActivity.ActivityType? ,completed : Bool ,returnedItems: [Any]? , activityError:Error? )in
                if completed {
                    print("completed")
                }else{
                    print("cancel")
                }
            }
            activityVC.completionWithItemsHandler = itemsBlock
            self!.present(activityVC, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
