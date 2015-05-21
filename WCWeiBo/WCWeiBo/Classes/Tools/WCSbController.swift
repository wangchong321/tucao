//
//  WCSbController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/15.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class WCSbController: NSObject {
    ////  提供storyboard的名称生成控制器
   class func sbController(sbName: String)->(UIViewController){
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateInitialViewController() as? UIViewController
        return vc!
    }
}
