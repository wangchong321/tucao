//
//  HomeRefresh.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/21.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class HomeRefresh: UIRefreshControl {
    
    override init() {
        super.init()
       prepareView()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // 准备子视图
    var refreshView : RefreshView?
    // 准备 UIRefreshControl
    private func prepareView(){
        
        let rView =  NSBundle.mainBundle().loadNibNamed("HomeRefresh", owner: nil, options: nil).last as! RefreshView
        addSubview(rView)
        rView.setTranslatesAutoresizingMaskIntoConstraints(false)
        /// 添加约束数组
        var cons = [AnyObject]()
       
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[rView(136)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["rView":rView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[rView(60)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["rView":rView])
        cons.append( NSLayoutConstraint(item: rView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        self.addConstraints(cons)
        
        
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        
        self.refreshView = rView
    }
    deinit{
        self.removeObserver(self, forKeyPath: "frame")
    }
    override func endRefreshing() {
        super.endRefreshing()
        // 停止动画
        refreshView?.stopLoading()
        // 
        isLoadingFlag = false
    }
    // 显示箭头标记
    var shouTipFlag = false
    // 显示正在加载标记
    var isLoadingFlag = false
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if self.frame.origin.y >= 0 {
            return
        }
        
        // 如果正在刷新 并且还没有转圈显示
        if refreshing && !isLoadingFlag{
            // 根据给的动画时长来结束动画
            println("正在加载")
            self.refreshView?.startLoding()
           
            isLoadingFlag = true
            return
        }

        if self.frame.origin.y > -50 && shouTipFlag{
            println("箭头该向下了")
            shouTipFlag = false
            refreshView?.rotateTipIcon(shouTipFlag)
        }else if self.frame.origin.y <= -50 &&  !shouTipFlag{
        println("箭头该向上了")
        shouTipFlag = true
        refreshView?.rotateTipIcon(shouTipFlag)
       
        // 箭头转向上边
        }
    }
}

class RefreshView: UIView {
    /// load视图(转圈图标)
    @IBOutlet weak var loadImgView: UIImageView!
    /// 箭头图标
    @IBOutlet weak var tipIcon: UIImageView!
    /// 提示视图
    @IBOutlet weak var tipView: UIView!
    
    /// 旋转箭头
    private func rotateTipIcon(whatDirection : Bool){
        var angel = CGFloat(M_PI) as CGFloat
        angel += whatDirection ? -0.01 : 0.01
        
        UIView.animateWithDuration(0.5) {
            self.tipIcon.transform = CGAffineTransformRotate(self.tipIcon.transform, CGFloat(M_PI))
        }

    }
    ///  开始加载
    func startLoding(){
        tipView.hidden = true
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = 0.5
        anim.repeatCount = MAXFLOAT
        anim.toValue = M_PI * 2
        loadImgView.layer.addAnimation(anim, forKey: nil)
        
    }
    
    ///  结束加载
    func stopLoading(){
    loadImgView.layer.removeAllAnimations()
        tipView.hidden = false
    }
    
    
}