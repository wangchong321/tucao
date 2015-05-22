//
//  StatusCell.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/18.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit
import SDWebImage
class StatusCell: UITableViewCell {
    /// 头像
    @IBOutlet weak var iconVIew: UIImageView!
    /// 作者
    @IBOutlet weak var authorLabel: UILabel!
    /// 创作时间
    @IBOutlet weak var createdLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabele: UILabel!
    // 图片视图宽度
    @IBOutlet weak var pictureViewWidth: NSLayoutConstraint!
    // 图片视图高度
    @IBOutlet weak var pictureViewHeigth: NSLayoutConstraint!
    
    @IBOutlet weak var pictureViewLayout: UICollectionViewFlowLayout!
  
    @IBOutlet weak var pictureView: UICollectionView!
    /// 底部视图
    @IBOutlet weak var bottomVIew: UIView!
    /// 转发文本
    @IBOutlet weak var retweetedLabel: UILabel!
    
    var status : Status?{
        didSet{
            authorLabel.text = status?.user?.name
            createdLabel.text = status?.created_at
            sourceLabel.text = status?.sources
            contentLabele.text = status?.text
            iconVIew.sd_setImageWithURL(status?.user?.iconUrl)
            let pSize = calcPictureViewSize(status!)
           
            pictureViewWidth.constant = pSize.viewSize.width
            pictureViewHeigth.constant = pSize.viewSize.height
            pictureViewLayout.itemSize = pSize.itemSize
            
            retweetedLabel?.text = (status?.retweeted_status?.user?.name ?? "") + ":" + (status?.retweeted_status?.text ?? "")
                       ///  刷新数据
            pictureView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       contentLabele.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
         retweetedLabel?.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        
    }
    ///  选择cell的id
    class func identifi(status : Status)->(String!){
        if status.retweeted_status != nil {
            return "RetweetedCell"
        }
      return "HomeCell"
        
    }
    ///  计算行高
    func rowHeight( status : Status ) -> CGFloat{
       self.status = status
        layoutIfNeeded()
        let y = CGRectGetMaxY(bottomVIew.frame)
       // println(y)
    return y
    }
private func calcPictureViewSize(status : Status) -> (viewSize : CGSize, itemSize : CGSize){
    let s: CGFloat = 90.0
    let itemSize = CGSizeMake(s, s)
    let m : CGFloat = 10.0
    /// 图片的数量
    let imageCount = status.pictureURLs?.count ?? 0
    ///  没有图片时
    if imageCount == 0 {
       // println("没有图片")
        return (CGSizeZero, itemSize)
    }
    /// 一张图片的时候 
    if imageCount == 1 {
        let key = status.pictureURLs![0].absoluteString
        let image = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(key)
       // println("单张图片\(image.size)\(imageCount)")
        return (image.size,image.size)
    }
    ///  四张图片的时
    if imageCount == 4 {
        var s = CGSizeMake(s * 2 + m, s * 2 + m)
      //  println("四张图片\(s)\(imageCount)")
        return (s, itemSize)
    }
    ///  多张图片时候
    //println("四张图片\(s)\(imageCount)")
    let row = CGFloat((imageCount - 1)/3 + 1)
    return (CGSizeMake(s * 3 + 2 * m, s * row + (row - 1) * m), itemSize)
    
    }
}


extension StatusCell : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
  
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCollectionCell", forIndexPath: indexPath) as! PictureCell
        cell.url = status!.pictureURLs![indexPath.item]
        
        return cell
    }
}
///  视图的cell
class PictureCell : UICollectionViewCell {
    @IBOutlet weak var iconView : UIImageView!
    var url : NSURL? {
        didSet{
           
            iconView.sd_setImageWithURL(url)
            
        }
    }
    
}
