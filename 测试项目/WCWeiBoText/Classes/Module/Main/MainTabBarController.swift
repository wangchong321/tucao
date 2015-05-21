    //
//  MainTabBarController.swift
//  WCWeiBoText
//
//  Created by 王充 on 15/5/11.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
    }
    
    func addChildViewControllers() {
        tabBar.tintColor = UIColor.orangeColor()
        addChildViewController("Home", title:"首页" , imgName: "tabbar_home")
        addChildViewController("Message", title:"信息" , imgName: "tabbar_message_center")
        addChildViewController("Discover", title:"发现" , imgName: "tabbar_discover")
        addChildViewController("Profile", title:"我" , imgName: "tabbar_profile")
    }
    
    
    
    func addChildViewController(storyboardName : String , title : String , imgName : String) {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let nav = sb.instantiateInitialViewController() as! UINavigationController
        nav.topViewController.title = title
        nav.tabBarItem.image = UIImage(named: imgName)
        nav.tabBarItem.selectedImage = UIImage(named:imgName + "_highlighted")
        addChildViewController(nav)
        }
 
}
