//
//  OAuthViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/12.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class OAuthViewController: UIViewController, UIWebViewDelegate {
    let WB_Client_Id = "284115638"
    let WB_Redirect_Uri = "http://www.baidu.com"
    let WB_Client_Secret = "d79134d8bf979346c62b8d6def6b42a2"
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 登陆的时候要将授权页面弹出
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id="+WB_Client_Id+"&redirect_uri="+WB_Redirect_Uri
        let url = NSURL(string: urlString)
        (view as! UIWebView).loadRequest(NSURLRequest(URL: url!))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/*
    http://m.weibo.cn/reg/index? 点击注册
    http://login.sina.com.cn/sso/logout.php? 切换账号
    https://api.weibo.com/oauth2/  点击取消
    https://api.weibo.com/oauth2/authorize? 登陆成功
    http://www.tucao.cc/?code=018659eb7b1366678882060abda5bb1d  code
*/
    // MARK - UIWebView的代理方法
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
//        println(request.URL!)
//        return true
        // 调用url完整的字符串String类型
        //println(request.URL!.absoluteString!)
        let requestString = request.URL!.absoluteString!
        if requestString.hasPrefix("https://api.weibo.com/")
        {
            return true
        }
        if !requestString.hasPrefix(WB_Redirect_Uri) {
            return false
        }
        // 下面要取得code=后面的字符串
        if request.URL!.query!.hasPrefix("code=") {
            // 截取后面的字符串  拿到code
            //lengthOfBytesUsingEncoding以utf8编码计算字符串长度
            let code = (request.URL!.query! as NSString).substringFromIndex("code=".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            loadAccessToken(code)
            println("验证码"+code)
        }else{
            println("用户拒绝")
            close()
        }
        return false
    }
    // 获取access_token
    func loadAccessToken(code:String){
        let parame = ["client_id":WB_Client_Id,
                        "client_secret":WB_Client_Secret,
                        "grant_type":"authorization_code",
                        "code":code,
                        "redirect_uri":WB_Redirect_Uri
        ]
        UserAccount.loadAccessToken(parame, comletion: { (account) -> () in
            if account == nil {
                // 错误处理
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                return
            }
            
                sharedUserAccount = account
                NSNotificationCenter.defaultCenter().postNotificationName(WCSwitchRootViewControllerNotification, object: "Main")
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            

        })
    }
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
  
}
