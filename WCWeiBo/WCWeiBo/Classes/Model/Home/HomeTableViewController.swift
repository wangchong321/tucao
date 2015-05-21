//
//  HomeTableViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/10.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class HomeTableViewController: BascTableViewController {
    @IBOutlet weak var titleBtn: WCTittleButton!
    @IBAction func friendsearchClick() {
        println(__FUNCTION__)
    }
    @IBAction func popClick() {
        presentViewController(WCSbController.sbController("QRCode"), animated: true, completion: nil)
        
    }
    var statuses : [Status]? {
        didSet{
            // 赋值后刷新数据
            tableView.reloadData()
        }
    }
    @IBAction func titleClick() {
        if titleBtn.titleLabel!.text == "首页" {
            return
        }
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let modalVC = sb.instantiateViewControllerWithIdentifier("pop") as! PopupTableViewController
        let x = (view.frame.width - 200)*0.5
        
        pm_presentViewController(modalVC, showFrame: CGRectMake(x, 56, 200, 240), animationAppearBlock: { (view, transitionContext) -> (NSTimeInterval) in
                       // 动画方法
            // 设置动画初始的形变
            view.transform = CGAffineTransformMakeScale(1.0, 0)
            // 设置图层的锚点
            view.layer.anchorPoint = CGPointMake(0.5, 0)
            
            UIView.animateWithDuration(1,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 5.0,
                options: nil,
                animations: { () -> Void in
                
                view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: { (_) -> Void in
                   
            })
                return 1.0
        }, animationDisappearBlock: { (view, transitionContext) -> (NSTimeInterval) in
           return 0.0
        }, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleLabel()
        if userLogin {
            loadData()
        }
       
    }
    func loadData(){
       Status.loadStatus { (Status) -> () in
       
//        for s in Status {
//            println("转发微博 \(s.retweeted_status?.text)")
//        }
        self.statuses = Status
        }
    }
    
    
    
    // 设置首页中间标题按钮
    private func setTitleLabel(){
        if sharedUserAccount != nil {
        titleBtn.setTitle(sharedUserAccount?.name, forState: UIControlState.Normal)
        }else {
            titleBtn.setImage(nil, forState:UIControlState.Normal)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        vieitorView?.setNoLoginImge("visitordiscover_feed_image_house", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过", isHome: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! StatusCell
        cell.status = statuses![indexPath.row]
        return cell
        
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    ///  计算行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
       let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! StatusCell
        return cell.rowHeight(status)
       // return 300
    }
  }
