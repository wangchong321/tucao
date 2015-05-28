//
//  UserAccount.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/13.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import Alamofire
class UserAccount: NSObject, NSCoding {
    // 2 定义属性
    // 用于调用access_token，接口获取授权后的access token。
    let access_token : String
    // access_token的生命周期，单位是秒数。
    let expires_in : NSTimeInterval
    // 获取到期时间
    let expireDate : NSDate
    // 当前授权用户的UID。
    let uid : String
    
    // 取得保存路径
   static let accountPath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as! String).stringByAppendingPathComponent("account.plist")
    // 友好显示名称
    var name : String?
    // 用户头像地址（大图），180×180像素
    var avatar_large : String?
    
    init(dic : [String:AnyObject]){
        access_token = dic["access_token"] as! String
        expires_in = dic["expires_in"] as! NSTimeInterval
        uid = dic["uid"] as! String
        expireDate = NSDate(timeIntervalSinceNow: expires_in)
        
    }
    
    class func loadAccessToken(parame:[String:String],comletion:(account: UserAccount?) ->())  {
        let urlString =  "https://api.weibo.com/oauth2/access_token"
        NetWorkingTools.requestJSON(.POST, urlString, parame) { (JSON) -> () in
            if JSON == nil {
                comletion(account: nil)
                return
            }
           // println(JSON)
            // 1已经获取了token 转换成字典下一步要把token保存起来
            let account = UserAccount(dic: JSON as![String:AnyObject])
            account.loadFullUserAccount(comletion)
        }
    }  ///  发送token从服务器获取用户信息
    func loadFullUserAccount(completion:(account: UserAccount?)->()){
        let paramet = ["access_token" : access_token , "uid":uid]
        
       // let params = ["access_token": access_token, "uid": uid]
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        NetWorkingTools.requestJSON(.GET, urlString, paramet) { (JSON) -> () in
                // 判断错误回调
                if  JSON == nil {
                    completion(account: nil)
                    return
                }
            
                if let dic = JSON as? [String : AnyObject] {
                    self.name = dic["name"]as? String
                    self.avatar_large = dic["avatar_large"] as? String
                    
                
                // 3 将获取到的account存档
                NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
                // 回调
                    completion(account: self)
                }else{
                    completion(account: nil)
                }
        }
    }
        
    
    
    
    ///  从沙盒中读取用户信息account
   class func loadUserAccount()->UserAccount?{
        // 判断是否有值
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount{
            // 判断时间
            if account.expireDate.compare(NSDate()) == NSComparisonResult.OrderedDescending{
                
                return account
            }
        }
        return nil
    }
    
   
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expireDate, forKey: "expireDate")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    required init(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as! String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as! String
        expireDate = aDecoder.decodeObjectForKey("expireDate") as! NSDate
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    // 重写对象的描述信息 - 建议重要的模型类，最好添加一个，方便调试
    override var description: String {
        let properties = ["access_token", "expires_in", "uid", "expireDate", "avatar_large", "name"]
        
        return "\(dictionaryWithValuesForKeys(properties))"
    }

}

