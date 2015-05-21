//
//  BascTableViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/10.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class BascTableViewController: UITableViewController ,VieitorViewDelegate{
    var userLogin = sharedUserAccount != nil
    var vieitorView: VieitorView?
    
    override func loadView() {
        if userLogin  {
             super.loadView()
            return
        }
        
        vieitorView = NSBundle.mainBundle().loadNibNamed("Visitor", owner: nil, options: nil).last as? VieitorView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewRegiesterViewDidSelected")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewLoginViewDidSelected")
        view = vieitorView
        vieitorView?.delegate = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    func visitorViewRegiesterViewDidSelected() {
        println("注册")
    }
    func visitorViewLoginViewDidSelected() {
    
        presentViewController(WCSbController.sbController("OAuth"), animated: true, completion: nil)
        println("登陆")
        
    }
   

}
