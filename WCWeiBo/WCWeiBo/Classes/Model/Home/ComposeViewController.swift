//
//  ComposeViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/22.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController ,UIScrollViewDelegate{
    /// 输入的textView文本框
    @IBOutlet weak var textView: UITextView!
    /// 模仿Placeholder 的labe
    @IBOutlet weak var textLabel: UILabel!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 发送按钮
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    ///  返回按钮
    @IBAction func dismsClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var pictureCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var toolBarHeightConstrain: NSLayoutConstraint!
    ///  发送微博
    @IBAction func sendClick(sender: AnyObject) {
        sendStatus()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureCollectionViewHeight.constant = 0
        nameLabel.text = sharedUserAccount?.name
        demoPlaceholder()
        registerNotification()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 开始键盘
        textView.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 结束键盘
        textView.resignFirstResponder()
    }
    private func demoPlaceholder(){
        if count(textView.text) > 0 {
            textLabel.hidden = true
        }
        textLabel.hidden = false
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //  注册通知
    private func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardChanged(notification : NSNotification) {
        println(notification)
        // 从 userInfo 字典中，取出键盘高度
        // 字典中如果保存的是结构体，通常是以 NSValue 的形式保存的
        
        var duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 如果监听的是键盘的frame改变事件,如果是则弹起键盘, 如果不是则放下键盘
        var height : CGFloat = 0
        if notification.name == UIKeyboardWillChangeFrameNotification {
            var rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            height = rect.height
        }
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            self.toolBarHeightConstrain.constant = height
            self.view.layoutIfNeeded()
        })
        
    }
    // 选中了图片按钮
    @IBAction func seletcPicture() {
        // 点击图片按钮的时候键盘弹下, 图片控制器显示
        pictureCollectionViewHeight.constant = UIScreen.mainScreen().bounds.height / 3
        
        textView.resignFirstResponder()
    }
    // Mark - UIScrollView的代理方法
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println(__FUNCTION__)
    }
    // 发送文字微博
    private func sendStatus(){
        var status = textView.text
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let parame = ["access_token" : sharedUserAccount?.access_token , "status" : status]
        NetWorkingTools.requestJSON(.POST, urlString, parame) { (JSON) -> () in
            println(JSON)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}


private let maxTextViewLength = 10
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        // println("\(textView.text)")
        // textView.text如果是空的就不隐藏.否则隐藏
        textLabel.hidden = !textView.text.isEmpty
        sendBtn.enabled = !textView.text.isEmpty
        var text = textView.text as NSString
        if text.length > maxTextViewLength{
            textView.text = text.substringToIndex(maxTextViewLength)
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        println(text)
        // 调整最大的传送字节上限
        if ((textView.text as NSString).length + (text as NSString).length) > 10 {
            
            return false
        }
        
        return true
    }
    
    
    
    
    
}