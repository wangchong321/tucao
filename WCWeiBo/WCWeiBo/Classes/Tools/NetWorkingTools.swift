//
//  NetWorkingTools.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/18.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class NetWorkingTools: NSObject {
    
    class func requestJSON(method : Alamofire.Method,_ urlString: String,_ parame: [String:AnyObject]? = nil,completion:(JSON : AnyObject?)->()){
        Alamofire.request(method, urlString, parameters: parame).responseJSON() { (_, _, JSON, error) -> Void in
            if error != nil || JSON == nil {
                // 查看程序的错误
                println("error:JSON-----"+"\(JSON)"+"ERROR:NetWorkingTools "+"\(error)")
                //completion(JSON : nil)
                SVProgressHUD.showInfoWithStatus("你的网路不给力")
                return
            }
     
            completion(JSON: JSON)
        }
}
}