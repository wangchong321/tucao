
//
//  MainTabBar.swift
//  WCWeiBoText
//
//  Created by 王充 on 15/5/11.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class MainTabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        let tabBarCount = 5
        let w = frame.width / CGFloat(tabBarCount)
        let h = frame.height
        let myFrame = CGRectMake(0, 0, w, h)
        var index = 0
        for v in subviews as![UIView]{
            if v is UIControl {
//-----------------------没有移除uibutton-----------------------------------------------------//
///  它是以rect为中心，根据dx，dy的值来扩大或者缩小，负值为扩大，正直为缩小。可以他们理解成为宽度和高度的偏移量。
                v.frame = CGRectOffset(myFrame, w * CGFloat(index), 0)
                index += index == 1 ? 2 : 1
            }
        }
        centerButton.frame = myFrame
       centerButton.center = CGPointMake(center.x, h*0.5)
        // 添加中间按钮
    }
    lazy var centerButton : UIButton = {
        let btn = UIButton.buttonWithType(UIButtonType.Custom)as! UIButton
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        self.addSubview(btn)
        return btn
    }()
}
