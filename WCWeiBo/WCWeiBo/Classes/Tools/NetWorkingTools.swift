//
//  NetWorkingTools.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/18.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
// 定义枚举
enum Method : String{
    case GET = "GET"
    case POST = "POST"
}
    
class NetWorkingTools: AFHTTPSessionManager {
    // 设置AFN单例
    private static let instance : NetWorkingTools = {
        let url = NSURL(string: "https://api.weibo.com/")
        let tools = NetWorkingTools(baseURL: url)
        // 设置默认超时时常
        tools.requestSerializer.timeoutInterval = 30
        // 设置响应格式
        tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        
        // 设置联网模式
        tools.reachabilityManager.setReachabilityStatusChangeBlock({ (status) -> Void in
            switch status {
            case AFNetworkReachabilityStatus.NotReachable:
                SVProgressHUD.showInfoWithStatus("您的网络好像断了", maskType: SVProgressHUDMaskType.Gradient)
            default:
                println(status)
            }
        })
        return tools
    }()
    class func shardManager() -> NetWorkingTools {
    return instance
    }
    
    
     //MARK - AFN抽取网络工具类
    class func requestJSON(method : Method,_ urlString: String,_ parame: [String:AnyObject]? = nil,completion:(JSON : AnyObject?)->()){
        if method == Method.GET {
            shardManager().GET(urlString, parameters: parame, success: { (_, JSON) -> Void in
                completion(JSON: JSON)
            }, failure: { (_, error) -> Void in
                println("ERROR 网络工具类.GET : \(error)")
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                completion(JSON: nil)
            })
        }else if method == Method.POST {
           shardManager().POST(urlString, parameters: parame, success: { (_, JSON) -> Void in
            completion(JSON: JSON)
            
           }, failure: { (_, error) -> Void in
            completion(JSON: nil)
            println("ERROR 网络工具类.POST : \(error)")
            SVProgressHUD.showInfoWithStatus("您的网络不给力")
           })
        }
    
    }
    //    // MARK - Alamofire抽取的工具类
    //    class func requestJSON(method : Alamofire.Method,_ urlString: String,_ parame: [String:AnyObject]? = nil,completion:(JSON : AnyObject?)->()){
    //        Alamofire.request(method, urlString, parameters: parame).responseJSON() { (_, _, JSON, error) -> Void in
    //            if error != nil || JSON == nil {
    //                // 查看程序的错误
    //                println("error:JSON-----"+"\(JSON)"+"ERROR:NetWorkingTools "+"\(error)")
    //                //completion(JSON : nil)
    //                SVProgressHUD.showInfoWithStatus("你的网路不给力")
    //                return
    //            }
    //
    //            completion(JSON: JSON)
    //        }
    //    }
}