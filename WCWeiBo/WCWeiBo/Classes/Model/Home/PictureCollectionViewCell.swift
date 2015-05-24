//
//  PictureCollectionViewCell.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/23.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

let WCSelectPictureNotifiction = "WCSelectPictureNotifiction"
let WCRemoviPictureNotifiction = "WCRemoviPictureNotifiction"

class PictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    var image : UIImage? {
        didSet{
            removeBtn.hidden = (image == nil)
            if image != nil {
                pictureBtn.setImage(image, forState: UIControlState.Normal)
                pictureBtn.setBackgroundImage(nil, forState: UIControlState.Normal)
            }else{
                pictureBtn.setImage(nil, forState: UIControlState.Normal)
                pictureBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
            }
            
        }
    }
    
    
    // 点击图片按钮
    @IBAction func pictureBtnClick() {
        println("pictureBtnClick")
        NSNotificationCenter.defaultCenter().postNotificationName(WCSelectPictureNotifiction, object: self)
    }
    // 点击移除按钮(叉)
    @IBAction func removeBtnClick() {
         println("removeBtnClick")
        NSNotificationCenter.defaultCenter().postNotificationName(WCRemoviPictureNotifiction, object: self)
    }
    
}
