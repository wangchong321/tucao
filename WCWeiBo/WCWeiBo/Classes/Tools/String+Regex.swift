//
//  String+Regex.swift
//  02-正则表达式
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import Foundation

extension String {
    ///
    ///
    ///  :returns: <#return value description#> href
    func hrefLink() -> (href: String, linkText: String)? {

        // 1. 匹配方案
        let pattern = "<a.*?href=\"(.*?)\".*?>(.*?)</a>"
        
        // 2. 实例化表达式
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: nil)
        
        // 3. 匹配
        if let result = regex?.firstMatchInString(self, options: NSMatchingOptions(0), range: NSMakeRange(0, count(self))) {
            
            // href
            let range1 = result.rangeAtIndex(1)
            // link text
            let range2 = result.rangeAtIndex(2)
            
            let href = (self as NSString).substringWithRange(range1)
            let linkText = (self as NSString).substringWithRange(range2)
            
            return (href, linkText)
        }
        return nil
    }
}