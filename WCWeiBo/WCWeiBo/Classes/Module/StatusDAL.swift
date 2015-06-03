//
//  StatusDAL.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/28.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
private let WB_HOME_LINE_URL = "https://api.weibo.com/2/statuses/home_timeline.json"
class StatusDAL: NSObject {

    class func loadStatus(#since_id : Int, max_id: Int, complete : (array : [[String : AnyObject]]?)->()){
        let manager = SQLiteManager.sharedSQLManager()
        let list = StatusDAL.loadCacheStatus(since_id: since_id, max_id: max_id)
        // 1.判断是否有本地数据,
        if list?.count > 0 {
            // 2.如果有从数据库加载
            println("从数据库加载数据")
            complete(array: list)
            return
        }
        
        // 3.如果没有从网络加载数据       
        var parame =  ["access_token":sharedUserAccount!.access_token]
        
        // 添加since_id
        if since_id > 0 {
            parame["since_id"] = "\(since_id)"
        }else if max_id > 0 {
            parame["max_id"] = "\(max_id - 1)"
        }
        
        NetWorkingTools.requestJSON(.GET, WB_HOME_LINE_URL, parame) { (JSON) -> () in
        
            if let array = (JSON as! NSDictionary)["statuses"] as? [[String :AnyObject]] {
                complete(array: array)
                println("从网络加载数据")
                // 4.将数据保存到数据库中
                StatusDAL.save(array)
                return
            }
            
            println("网络加载的数据为空")
            complete(array: nil)
        }
    }
    ///  从数据库中加载保存的数据
    class func loadCacheStatus(#since_id : Int, max_id: Int) -> [[String : AnyObject]]? {
        let manager = SQLiteManager.sharedSQLManager()
        var sql = "SELECT status FROM T_Status \n"
        sql += "WHERE userId = \(sharedUserAccount!.uid) \n"
        // 判断id
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        }else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20"
        var list = manager.execRecordSet(sql)
        println(sql)
        var result : [[String : AnyObject]]?
        if list != nil {
            result = [[String : AnyObject]]()
            for dic in list! {
                // 拿出字典中的字符串
                let str = dic["status"] as! String
                // 将字符串转换成二进制数据
                let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
                // 反序列化
                let d = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as! [String : AnyObject]
                result!.append(d)
            }
        }
        println(result!.count)
        return result
    }
    
    /// 将网络获取的数据保存到数据库中
    class func save(array : [[String : AnyObject]]){
        // 将网络获取的数据保存到数据库中
        let userId = sharedUserAccount!.uid
        // 开启事物
        let manager = SQLiteManager.sharedSQLManager()
        manager.beginTransction()
        
        // 将数据插入
        // 1. 准备sql OR REPLACE插入或者替换
        let sql = "INSERT OR REPLACE INTO T_Status (statusId ,status, userId) VALUES(?, ? ,?);"
        var result = true
        for dict in array {
            var statusId = dict["id"] as! Int
            // 将字典序列化
            var data = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil)!
            // 将二进制数据转换成字符串
            var jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            result = manager.execUpdate(sql, params: statusId, jsonString, userId)
            // 如果失败跳出循环
            if !result {
                break
            }
        }
        // 回滚
        if result {
            manager.commitTransction()
            println("提交事物")
        }else {
            manager.rollbackTransction()
            println("回滚事物")
        }
        
        
    }
}
