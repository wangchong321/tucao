//
//  VieitorView.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/10.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

protocol VieitorViewDelegate : NSObjectProtocol
{
    func visitorViewLoginViewDidSelected()
    func visitorViewRegiesterViewDidSelected()
}

class VieitorView: UIView {
    
    @IBOutlet weak var scrollImgView: UIImageView!
    @IBOutlet weak var smallImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate : VieitorViewDelegate?
    func setupInfo(imageName: String, message: String, isHome: Bool = false){
        titleLabel.text = message
    }
    
    func setNoLoginImge(smallImgName: String , title: String , isHome: Bool = false) {
        if isHome {
            smallImgView.image = UIImage(named: smallImgName)
        }else{
            bringSubviewToFront(scrollImgView)
            scrollImgView.image = UIImage(named: smallImgName)
            smallImgView.hidden = true
        }
        titleLabel.text = title
        isHome ? startAnimation() : endAnimation()
        
    }
    
    func startAnimation(){
        let anim = CABasicAnimation()
        anim.keyPath = "transform.rotation"
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 20.0
        scrollImgView.layer.addAnimation(anim, forKey: "zhuan")
        
    }
    func endAnimation(){
        scrollImgView.layer.removeAnimationForKey("zhuan")
    }
    @IBAction func register() {
        delegate?.visitorViewRegiesterViewDidSelected()
        
    }
    @IBAction func login() {
        delegate?.visitorViewLoginViewDidSelected()
    }
    
   
}
