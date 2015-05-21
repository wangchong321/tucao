//
//  QRCodeViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/15.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import SwiftQRCode
import SDWebImage
let qrCode = QRCode(autoRemoveSubLayers: false, lineWidth: 2, strokeColor: UIColor.orangeColor(), maxDetectedCount: 20)
class QRCodeViewController: UIViewController ,UITabBarDelegate{
    
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var QcodeBarItem: UITabBar!
    @IBOutlet weak var weightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    private func statrAnimation(){
        self.topConstant.constant = -self.heightConstant.constant
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.topConstant.constant = self.heightConstant.constant
            self.view.layoutIfNeeded()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        statrAnimation()
        scan()
        tabbar.selectedItem = tabbar.items![0] as? UITabBarItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        // 点击条形码按钮的时候更新约束
        heightConstant.constant = item.tag == 1 ? heightConstant.constant*0.5 : weightConstraint.constant
        view.layer.removeAllAnimations()
        statrAnimation()
    }
    
    // 开始扫描
    private func scan(){
       // let str = NSString(string: sharedUserAccount!.avatar_large!)
        let urlString = NSURL(string: sharedUserAccount!.avatar_large!)
        let imgView = UIImageView()
        imgView.sd_setImageWithURL(urlString)
       qrCode.scanCode(view, completion: { (stringValue) -> () in
       
       })   
    }
   
}
