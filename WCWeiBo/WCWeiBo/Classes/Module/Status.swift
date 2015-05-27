//
//  Status.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/18.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import SDWebImage
private let WB_HOME_LINE_URL = "https://api.weibo.com/2/statuses/home_timeline.json"
class Status: NSObject {
    //// 创建微博的时间
    var created_at : String?{
        didSet{
            createdDate = NSDate.createDate(created_at!)
        }
    }
    /// 现在的时间
    var createdDate : NSDate?
    /// 微博ID
    var id : Int = 0
    /// 微博信息内容
    var text : String?
    /// 微博来源
    var sources : String?
    /// 配图数组
    var pic_urls : [[String:String]]? {
        didSet{
            imageURLs = [NSURL]()
            for dic in self.pic_urls! {
                var url = NSURL(string: dic["thumbnail_pic"]!)
                imageURLs?.append(url!)
            }
        }
    }
    
    // 配图的url数组
    var imageURLs : [NSURL]?
    
    var pictureURLs : [NSURL]?{
        if retweeted_status != nil{
            return retweeted_status?.imageURLs
        }else{
            return imageURLs
        }
    }
    
    
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 表态数
    var attitudes_count: Int = 0
    
    /// 用户
    var user : User?
    
    /// 转发微博记录
    var retweeted_status : Status?
    ///  属性数组
    private static let properties = ["created_at","id","text","sources","pic_urls","reposts_count","comments_count","attitudes_count"]
    
    init(dic : [String: AnyObject]) {
        super.init()
        for key in Status.properties {
            if dic[key] != nil {
                setValue(dic[key], forKey: key)
            }
        }
        
        if dic["user"] != nil {
            user = User(dic: dic["user"] as! [String : AnyObject])
        }
        if dic["retweeted_status"] != nil {
            retweeted_status = Status(dic: dic["retweeted_status"] as! [String : AnyObject] )
        }
    }
    
    /// 设置刷新数据
    class func loadStatus(#since_id : Int, max_id: Int, complete : (statuses:[Status]?)->()){
        var parame =  ["access_token":sharedUserAccount!.access_token]
        
        // 添加since_id
        if since_id > 0 {
            parame["since_id"] = "\(since_id)"
        }else if max_id > 0 {
            parame["max_id"] = "\(max_id)"
        }
        
        NetWorkingTools.requestJSON(.GET, WB_HOME_LINE_URL, parame) { (JSON) -> () in
            
            if let array = (JSON as! NSDictionary)["statuses"] as? [[String :AnyObject]] {
                let result = self.statuses(array)
                self.cacheStatusImage(result, complete: complete)
                return
            }
            complete(statuses: nil)
            
        }
    }
    ///  缓存图片
    private class func cacheStatusImage(status : [Status]?,complete :(status: [Status]?)->()) {
        if status == nil {
            complete(status: nil)
            return
        }
        
        // 简历一个dispatch_group, 监听一组异步任务完成后,同意得到通知
        let group =  dispatch_group_create()
        for s in status as [Status]! {
            if s.pictureURLs == nil {
                continue
            }
            // 到这一定有图片,所以保存图片
            for url in s.pictureURLs!{
                dispatch_group_enter(group)
                NSHomeDirectory()
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: nil, progress: nil, completed: { (_, _, _, _, _) -> Void in
                    
                    dispatch_group_leave(group)
                    
                })
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), { () -> Void in
            // println("图片缓存完成+加载数据 \(NSHomeDirectory())")
            // 执行回调
            complete(status: status)
        })
    }
    
    private class func statuses(array : [[String: AnyObject]]) -> [Status]?{
        if array.count == 0 {
            return nil
        }
        var arrayM = [Status]()
        for dic in array {
            let sta = Status(dic: dic)
            
            arrayM.append(sta)
        }
        return arrayM
    }
}
