//
//  WelcomeViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/14.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
class WelcomeViewController: UIViewController {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
        // 登陆的时候执行动画
       constraint.constant = view.bounds.height - constraint.constant
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 45
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: nil, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (_) -> Void in
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: nil, animations: { () -> Void in
                self.welcomeLabel.alpha = 1.0
            }, completion: { (_) -> Void in
                // 欢迎界面结束
                NSNotificationCenter.defaultCenter().postNotificationName(WCSwitchRootViewControllerNotification, object: "Main")
            })
        }
        
        
    }
///  设置头像与用户姓名
    func setAvatarAndName(){
        if (sharedUserAccount?.avatar_large != nil) {
            
        let urlStr = sharedUserAccount?.avatar_large
        let url = NSURL(string: urlStr!)
        self.avatarView.sd_setImageWithURL(url)

///  如果用户修改了姓名或者图片,则能第一时间修改
//            sharedUserAccount?.loadFullUserAccount({ (account, error) -> () in
//                if account != nil {
//                    
////                   self.welcomeLabel.text = sharedUserAccount?.name
////
////                    let urlStr = sharedUserAccount?.name
////                    let url = NSURL(string: urlStr!)
////                    self.avatarView.sd_setImageWithURL(url)
//                   
////                    return
//                }
//            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ///  设置头像姓名
        setAvatarAndName()
     
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  }
