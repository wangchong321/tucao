//
//  AppDelegate.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/10.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import SVProgressHUD
var sharedUserAccount = UserAccount.loadUserAccount()
let WCSwitchRootViewControllerNotification = "WCSwitchRootViewControllerNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        // 添加通知中心
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootControllerNotification:", name: WCSwitchRootViewControllerNotification, object: nil)
        //设置主界面
        switchRootController()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        return true
    }
    // 控制器跳转 注意不能将通知中心的方法设为私有 否则进不来
    func switchRootControllerNotification(n: NSNotification) {
       window?.rootViewController = WCSbController.sbController(n.object as! String)
    }

    /// 判断开场控制器
    private func switchRootController(){
        var sbName = "Main"
        if sharedUserAccount != nil {
            sbName = analyzingNewVersion() ? "Welcome" : "NewFeature"
        }
        window?.rootViewController = WCSbController.sbController(sbName)
    }
    
    // 判断新版本
    private func analyzingNewVersion()->Bool{
        // 取出当前版本
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]as! String
        
        // 取出上一次版本
        let userDefauls = NSUserDefaults.standardUserDefaults()
        let lastVersion = userDefauls.stringForKey("BundleShortVersionString")
        
        // 保存当前版本号
        userDefauls.setObject(version, forKey: "BundleShortVersionString")
        return version == lastVersion
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

