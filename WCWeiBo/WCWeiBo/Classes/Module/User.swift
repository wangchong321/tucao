//
//  User.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/18.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class User: NSObject {
    /// 用户UID
    var id : Int = 0
    ///  友好显示名称
    var name : String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url :String? {
        didSet{
            iconUrl = NSURL(string: profile_image_url!)
        }
    }
    // 头像url
    var iconUrl : NSURL?
    /// 是否是微博认证用户，即加V用户，true：是，false：否
    var verified: Bool = false
    ///  认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 草根明星
    var verified_type : Int = -1
    /// 属性数组
    // 1～6 一共6级会员
    var mbrank: Int = 0
    private static let proparties = ["id","name","profile_image_url","verified","verified_type","mbrank"]
    
    init(dic : [String : AnyObject]){
        super.init()
        for key in User.proparties {
            if dic[key] != nil {
                setValue(dic[key], forKey: key)
                
            }
        }

    
    }
}
