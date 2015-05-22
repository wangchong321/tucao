//
//  MainTabBarController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/10.
//  Copyright (c) 2015年 王充. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

   
    @IBOutlet weak var myTabBar: MainTabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        myTabBar.centerButton.addTarget(self, action: "centerbtnClick", forControlEvents: UIControlEvents.TouchUpInside)
    }
    ///  点击中间按钮
    func  centerbtnClick(){
        presentViewController(WCSbController.sbController("Compose"), animated: true, completion: nil)
    }
    func  addChildViewControllers() {
       
       tabBar.tintColor = UIColor.orangeColor()
        addChildViewController("Home", "首页", "tabbar_home")
        addChildViewController("Message", "信息", "tabbar_message_center")
        addChildViewController("Discover", "发现", "tabbar_discover")
        addChildViewController("Profile", "我", "tabbar_profile")
    }
    
    
    
    func  addChildViewController(sbName: String,_ titliName: String,_ imgName: String) {
       let nav = WCSbController.sbController(sbName) as? UINavigationController
       // nav?.title = titliName
        nav?.tabBarItem.image = UIImage(named: imgName)
        nav?.tabBarItem.selectedImage = UIImage(named: imgName + "_highlighted")
        addChildViewController(nav!)
        nav?.tabBarItem.title = titliName
        nav?.topViewController.title = titliName
        
        
    }
}
