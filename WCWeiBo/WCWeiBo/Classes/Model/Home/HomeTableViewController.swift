//
//  HomeTableViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/10.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class HomeTableViewController: BascTableViewController,UIScrollViewDelegate,StatusCellDelegate {
    @IBOutlet weak var titleBtn: WCTittleButton!
    /// 行高缓存
    var rowHeightCache = NSCache()
    // 记录上一次滚动的位置
    var lasecontenoffset :CGFloat = 0
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
            let time = 2.0
            let time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * (Double)(NSEC_PER_SEC)))
            dispatch_after(time_t, dispatch_get_main_queue(), { () -> Void in
                
                self.refreshControl?.endRefreshing()
            })
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
        ///  用户登录后才需要刷新数据
        if !userLogin {
            return
        }
        
        setupRefreshControl()
    }
    func setupRefreshControl(){
        self.refreshControl = HomeRefresh()
        println("lodaData 开始加载了")
        self.refreshControl!.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        
        loadData()
    }
    
    var pullupRefrechFlag = false
    var firstLoad = true
    func loadData(){
        // 如果是第一次登陆则加载已经缓存好的数据
        if firstLoad {
        refreshControl?.beginRefreshing()
        }
        // 如果是下拉刷新
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        // 如果是上啦刷新
        if pullupRefrechFlag {
            
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        Status.loadStatus(since_id: since_id , max_id : max_id) { (statuses) -> () in
            
            if statuses == nil {
                println("没有新数据")
                let time = 2.0
                let time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * (Double)(NSEC_PER_SEC)))
                dispatch_after(time_t, dispatch_get_main_queue(), { () -> Void in
                    
                    self.refreshControl?.endRefreshing()
                })
                
                return
            }
            if since_id > 0 {
                self.statuses = statuses! + self.statuses!
            }else if max_id > 0 {
                self.statuses! += statuses!
                self.pullupRefrechFlag = false
                println("上拉刷新完成")
                return
            }
            self.statuses = statuses
            self.firstLoad = false
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
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCell.identifi(statuses![indexPath.row])) as! StatusCell
        cell.status = statuses![indexPath.row]
        cell.pictureDelegate = self
        // 如果是最后一个则是下拉刷新 并且第一次进
        if indexPath.row == (statuses!.count - 1) && !pullupRefrechFlag {
            pullupRefrechFlag = true
            loadData()
        }
        return cell
        
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    ///  计算行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        
        if rowHeightCache.objectForKey(status.id) != nil {
            return rowHeightCache.objectForKey(status.id) as! CGFloat
        }
        
        let s =  StatusCell.identifi(status)
        let cell = tableView.dequeueReusableCellWithIdentifier(s) as! StatusCell
        let h = cell.rowHeight(status)
        // 将高度缓存起来
        rowHeightCache.setObject(h, forKey: status.id)
        
        return h
    }
    // MARK - statusCell的代理方法
    func statusCellDidSelectPicture(statusCell: StatusCell, indexPathInt: Int) {
        println(indexPathInt)
        
    }
}
extension HomeTableViewController: UIScrollViewDelegate {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 60 {
            return
        }
        var s = scrollView.contentOffset.y - lasecontenoffset
        if s > 0 {
            // 到这里要隐藏itembar
            
            // 执行动画隐藏
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                
                navigationController?.navigationBar.frame.origin.y = -44
            })
            
        }else{
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                
                navigationController?.navigationBar.frame.origin.y = 20
                
            })
            
        }
        // 记录上一次
        lasecontenoffset = scrollView.contentOffset.y
        
    }
}