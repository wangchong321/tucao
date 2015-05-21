//
//  VisitorView.swift
//  WCWeiBoText
//
//  Created by 王充 on 15/5/11.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

protocol VisitorViewDelegate : NSObjectProtocol{
    func visitorViewLoginButtonClick()
    func visitorViewregisterButtonClick()
}

class VisitorView: UIView {
    weak var delegate : VisitorViewDelegate?
    @IBOutlet weak var BigImgView: UIImageView!
    @IBOutlet weak var smallImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func setNoLoginImage(bigImgName : String, smallImgName :String , title : String, isHome : Bool){
        isHome ? startAnimation() : stopAnimation()
        smallImgView.hidden = !isHome
        if isHome {
            // 如果是首页将图片赋给小图, 大图给转轮
            smallImgView.image = UIImage(named: smallImgName)
            
        }else{
            // 至于顶层否则看不见下面
            bringSubviewToFront(BigImgView)
            BigImgView.image = UIImage(named: smallImgName)
        }
        titleLabel.text = title
        
    }
    func startAnimation() {
        let anim = CABasicAnimation()
        anim.toValue = M_PI * 2
        anim.duration = 20.0
        anim.repeatCount = MAXFLOAT
        anim.keyPath = "transform.rotation"
      BigImgView.layer.addAnimation(anim, forKey: "zhuan")
    }
    func stopAnimation(){
        BigImgView.layer.removeAnimationForKey("zhuan")
    }
    @IBAction func registerClick() {
        delegate?.visitorViewregisterButtonClick()
    }
    @IBAction func loginClick() {
        delegate?.visitorViewLoginButtonClick()
    }
}
