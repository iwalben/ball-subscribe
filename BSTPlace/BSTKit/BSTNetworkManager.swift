//
//  BSTNetworkHelper.swift
//  BSTAccount
//
//  Created by Roddick on 2019/12/10.
//  Copyright © 2019 Roddick. All rights reserved.
//

import UIKit
import Alamofire


typealias BSTNetworkClosure = ([String:Any]) -> (Void)

class BSTNetworkManager{
    private static var sharedNetworkManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0//请求超时时间
        return Session(configuration: configuration)
    }()
    
    static public func postRequestDataWithEncodingParams(params:[String:Any] = ["":""] , url:String = "" ,completionHandle:@escaping BSTNetworkClosure){
        let headers: HTTPHeaders = [
            "Accept": "application/json,text/json,text/javascript,text/plain,text/html",
            "Content-type" : "application/json"
        ]
        AF.request(url, method: .post, parameters: params ,encoding:JSONEncoding.default ,headers: headers).responseJSON { (response) in
            print(response)
            switch response.result{
                case .success(let value) :
                    let jsonDic = value as! [String: Any]
                    completionHandle(jsonDic)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
