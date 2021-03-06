//
//  Emoticons.swift
//  01-表情键盘
//
//  Created by apple on 15/5/23.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import UIKit

class Emoticons: NSObject {
   
    /// 分组名称
    var emoticon_group_name: String?
    /// 分组路径
    var emoticon_group_path: String?
    /// 表情文本
    var chs: String?
    /// 图片名称
    var png: String?
    /// emoji 代码
    var code: String?
    /// 是否删除按钮标记
    var isRemoveButton = false
    
    /// 图像路径
    var imagePath: String? {
        // 判断是否有图像
        if png != nil {
            return emoticon_group_path!.stringByAppendingPathComponent(png!)
        }
        return nil
    }
    
    /// emoji 字符串
    var emojiStr: String?
    
    init(groupName: String, groupPath: String, dict:[String: String]?) {
        super.init()

        emoticon_group_name = groupName
        emoticon_group_path = groupPath

        chs = dict?["chs"]
        png = dict?["png"]
        code = dict?["code"]
        
        if code != nil {
            // scanner 是专门用来扫描字符串的
            let scanner = NSScanner(string: code!)
            // 扫描其中的16进制数字
            // 提示：scanner 的扫描结果会输出到 result，不能使用 let
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            
            emojiStr = "\(Character(UnicodeScalar(result)))"
        }
    }
    
    /// 定义一个静态的数组，记录表情文字
    /// 优化性能，避免重复加载数组
    static let emoticonsArray = Emoticons.emoticonsList()
    
    /// 将带表情符号的字符串，生成带图片的属性字符串
    class func emoticonString(string: String, lineHeight: CGFloat) -> NSAttributedString {
    
        // 利用正则表达式过滤表情符号
        // 1. 匹配方案，注意：[] 是正则表达式中的保留字，不能直接使用，如果要用，需要使用 \\ 转义
        // 因为 [] 是表情符号的一个标记
        let pattern = "\\[(.*?)\\]"
        
        // 2. 正则表达式
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: nil)
        
        // 3. 开始多个匹配
        // 3.1 根据字符串创建完整的可变属性文本
        var strM = NSMutableAttributedString(string: string)
        
        // 判断是否找到匹配项
        if let results = regex?.matchesInString(string, options: NSMatchingOptions(0), range: NSMakeRange(0, count(string))) {
            
            // 遍历匹配的结果
            var index = results.count - 1
            while index >= 0 {
                let r = results[index--] as! NSTextCheckingResult
                
                let range = r.rangeAtIndex(0)
                let emoticonStr = (string as NSString).substringWithRange(range)
                
                // 使用表情符号过滤出表情对象
                let emoticon = Emoticons.emoticonsArray.filter { $0.chs == emoticonStr }.last
                
                // 判断是否找到表情对象
                if emoticon != nil {
                    // 生成表情属性字符串
                    let attrString = EmoticonsAttachment.emoticonString(emoticon!, height: lineHeight)
                    
                    // 替换可变字符串
                    strM.replaceCharactersInRange(range, withAttributedString: attrString)
                }
            }
        }
        
        // 所有的结果就完成了
        return strM
    }
    
    /// 返回所有的表情符号数组
    private class func emoticonsList() -> [Emoticons] {
    
        var list = [Emoticons]()
        
        // 1. 加载 emoticons.plist（分组名&分组路径）
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        let array = (NSArray(contentsOfFile: path!) as! [[String: String]]).sorted { (dict1, dict2) -> Bool in
            return dict1["emoticon_group_type"] < dict2["emoticon_group_type"]
        }
        
        // 2. 遍历表情分组的数组
        for dict in array {
            // 将所有的表情分组加载
            // 因为：bundle是固定的，是会随着程序一起打包的
            // 如果运行的时候，程序崩溃，程序员就应该第一时间修改，而不用使用 let 判断
            let groupPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("Emoticons.bundle").stringByAppendingPathComponent(dict["emoticon_group_path"]!)
            
            println(groupPath)
            list += groupEmoticonsList(dict["emoticon_group_name"]!, groupPath: groupPath)
        }
        
        return list
    }
    
    /// 加载并且返回指定分组的表情数组
    private class func groupEmoticonsList(groupName: String, groupPath: String) -> [Emoticons] {
     
        var list = [Emoticons]()
        
        // 1. 加载 info.plist
        let infoPath = groupPath.stringByAppendingPathComponent("info.plist")
        let dict = NSDictionary(contentsOfFile: infoPath)!
        // 取出表情符号数组
        let array = dict["emoticon_group_emoticons"] as! [[String: String]]
        
        // 2. 遍历数组创建表情数据
        /**
        表情数组需要满足以下条件
        
        - 每页需要 21 个表情
        - 每遍历 20 个表情插入一个删除按钮
        - 如果不足 20 需要插入空表情，以方便在 collectionView 中占位
        - 目标：每个分组的表情数量应该是 21 的整数倍
        */
        var count = 0
        for dict in array {
            list.append(Emoticons(groupName: groupName, groupPath: groupPath, dict: dict))
            
            count++
            if count == 20 {
                // 生成一个删除的表情
                let e = Emoticons(groupName: groupName, groupPath: groupPath, dict: nil)
                e.isRemoveButton = true
                
                list.append(e)
                count = 0
            }
        }
        
        // 如果当前数组不能被21整除，需要补足空表情
        var emptyCount = list.count % 21
        if emptyCount != 0 {
            println("需要补足表情 \(emptyCount)")
            
            // 创建空表情
            for i in emptyCount..<21 {
                let e = Emoticons(groupName: groupName, groupPath: groupPath, dict: nil)
                
                list.append(e)
            }
            // 最后一个是删除按钮
            list.last?.isRemoveButton = true
        }

        // 重要的调试代码
//        var index = 0
//        println("--------")
//        for e in list {
//            println("\(index++) \(e.emoticon_group_name) \(e.chs) \(e.code) \(e.isRemoveButton)")
//        }
        
        return list
    }
}
