//
//  BasicTableViewController.swift
//  WCWeiBoText
//
//  Created by 王充 on 15/5/11.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class BasicTableViewController: UITableViewController, VisitorViewDelegate {
    var visitorView : VisitorView?
    var userLogin = false
    override func loadView() {
        if userLogin == true{
            super.loadView()
            return
        }
       visitorView = NSBundle.mainBundle().loadNibNamed("Visitor", owner: nil, options: nil).last as? VisitorView
        view = visitorView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewregisterButtonClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewLoginButtonClick")
        visitorView?.delegate = self
    }
    func visitorViewLoginButtonClick() {
        println("登陆")
    }
    func visitorViewregisterButtonClick() {
        println("注册")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

   
}
