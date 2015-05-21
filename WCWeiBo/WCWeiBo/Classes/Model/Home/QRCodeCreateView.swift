//
//  QRCodeCreateView.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/15.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class QRCodeCreateView: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let urlString = NSURL(string: sharedUserAccount!.avatar_large!)
//        let imgView1 = UIImageView()
//        imgView.sd_setImageWithURL(urlString)
        let urlString = NSURL(string: sharedUserAccount!.avatar_large!)
        let data = NSData(contentsOfURL: urlString!)
//        //let img = UIImage(
//         imgView.sd_setImageWithURL(urlString)
//        imgView2.sd_setImageWithURL(urlString)
        let image = UIImage(data: data!)
        
        let rect = imgView2.bounds
        let scale = 0.3 as CGFloat
        UIGraphicsBeginImageContext(rect.size)
        
        
        let avatarSize = CGSizeMake(rect.size.width * scale, rect.size.height * scale)
        let x = (rect.width - avatarSize.width) * 0.5
        let y = (rect.height - avatarSize.height) * 0.5
        image!.drawInRect(CGRectMake(x, y, avatarSize.width, avatarSize.height))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        
        
        imgView2.image = result
       
        imgView.image = qrCode.generateImage("王充3000", avatarImage:image , avatarScale: 0.25, color: CIColor(red: 1, green: 1, blue: 1), backColor: CIColor(red: 0, green: 0, blue: 0))

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
