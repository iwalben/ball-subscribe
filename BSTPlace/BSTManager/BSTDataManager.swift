//
//  BSTDataManager.swift
//  BSTPlace
//
//  Created by Roddick on 2020/3/12.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import RealmSwift

class Issue : Object {
//    //主键
//    @objc dynamic var id = 0
//    
    @objc dynamic var startTime = ""
    
    @objc dynamic var nickname = ""

    @objc dynamic var headImage = Data()

    @objc dynamic var content = ""

    dynamic var images = List<Data>()
    
    @objc dynamic var like = 0
    
    @objc dynamic var dislike = 0
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}

class BSTDataManager: NSObject {
    static let shareManager: BSTDataManager = {
        let instance = BSTDataManager()
        return instance
    }()
    
    var footballPlaceDatas : [BSTSquareModel]?
    
    private let realm = try! Realm()
    
    func configuralRealm() -> Void {
        /* Realm 数据库配置，用于数据库的迭代更新 */
        let schemaVersion: UInt64 = 0
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            /* 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构 */
            if (oldSchemaVersion < schemaVersion) {}
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            /* Realm 成功打开，迁移已在后台线程中完成 */
            if let _ = realm {
                print("Realm 数据库配置成功")
            }
            /* 处理打开 Realm 时所发生的错误 */
            else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
    
    //增
    func addIssue(issue: Issue) -> Void {
        try! realm .write {
            realm.add(issue)
        }
    }

    //删
    func deleteIssue(issue:Issue) -> Void {
        try! realm.write {
            realm.delete(issue)
        }
    }

    func deleteAllIssue() -> Void {
        try! realm.write {
            realm.deleteAll()
        }
    }

    //查
    func queryAllIssue() -> Results<Issue> {
        //从默认的 Realm 数据库中遍历所有 Issue 对象
        let issues = realm.objects(Issue.self)
        
        return issues
    }
    
    
    //条件查询
    func queryIssue(nickname:String) -> Results<Issue> {
        let issues = realm.objects(Issue.self).filter("nickname = '\(nickname)'")
        return issues
    }

    
}
