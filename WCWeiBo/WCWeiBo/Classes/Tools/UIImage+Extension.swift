//
//  UIImage+Extension.swift
//  HMWeibo06
//
//  Created by apple on 15/5/22.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
    将图像缩放到指定的宽度
    
    :param: width 目标宽度
    
    :returns: 缩放后的图像
    */
    func scaleImage(#width: CGFloat) -> UIImage {
        
        let size = scaleImageSize(width: width)
        
        // 1. 开启上下文
        UIGraphicsBeginImageContext(size)
        
        // 2. 在上下文中绘制图像，在rect中拉伸绘制
        self.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        // 3. 取出结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4. 关闭上下文
        UIGraphicsEndImageContext()
        
        return result
    }
    
    private func scaleImageSize(#width: CGFloat) -> CGSize {
        let scale = size.width / width
        let h = size.height / scale
        
        return CGSizeMake(width, h)
    }
}
