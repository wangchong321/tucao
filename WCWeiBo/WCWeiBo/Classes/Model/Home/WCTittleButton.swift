//
//  WCTittleButton.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/14.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class WCTittleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if titleLabel?.text == "首页"{
            return
        }
        
        imageView!.frame = CGRectOffset(imageView!.frame, titleLabel!.frame.width, 0)
        titleLabel!.frame = CGRectOffset(titleLabel!.frame, -imageView!.frame.width, 0)
    }

}
