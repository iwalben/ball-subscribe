//
//  BSTCommunityController.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/11.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class BSTCommunityController: BSTBaseController,UITableViewDelegate , UITableViewDataSource {
    
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
    
    var issues = BSTDataManager.shareManager.queryAllIssue()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: BSTScreenW, height: BSTScreenH - BSTNavigationHeight - BSTTabBarHeight)
        
        tableView.mj_header = BSTHeader.init(refreshingBlock: { [weak self]  in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self?.tableView.mj_header.endRefreshing()
            })
        })
        tableView.mj_header.beginRefreshing()
        let plus = UIButton()
        plus.setTitle("发布", for: .normal)
        plus.addTarget(self, action: #selector(plusClick as (UIButton) -> ()) , for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView:plus)
    }
    
    @objc func plusClick(_:UIButton){
        let ap = UserDefaults.standard.object(forKey: BSTLoginSuccess)
        if ap == nil {
            if #available(iOS 11.0, *) {
                let addVC: LoginViewController = LoginViewController.init()
                let addNavC: BSTBaseNavigationController = BSTBaseNavigationController.init(rootViewController: addVC)
                addNavC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(addNavC, animated: false, completion: {})
            } else {
                // Fallback on earlier versions
            }
            return 
        }
        
        let vc = BSTIssueController.init()
        vc.handle = {[weak self] in
            self!.issues = BSTDataManager.shareManager.queryAllIssue()
            self!.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
