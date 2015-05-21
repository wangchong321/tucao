//
//  MainTabBar.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/10.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class MainTabBar: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tabBarNum = 5
        let w = frame.width / CGFloat(tabBarNum)
        let h = frame.height
        let myFrame = CGRectMake(0, 0, w, h)
        var index = 0
        for v in subviews as! [UIView]{
            if v is UIControl && !(v is UIButton) {
                // 设置frame
                let x = CGFloat(index) * w
                v.frame = CGRectMake(x ,CGFloat(0), w, h)
               // println(v)
                index += (index == 1) ? 2 : 1
            }
        }
        // 设置中间按钮的frame
        centerButton.frame = CGRectMake(w * CGFloat(2), 0, w, h)
        
    }
    lazy var centerButton : UIButton = {
        let btn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        //btn.backgroundColor = UIColor.redColor()
        self.addSubview(btn)
        return btn
        }()


}
