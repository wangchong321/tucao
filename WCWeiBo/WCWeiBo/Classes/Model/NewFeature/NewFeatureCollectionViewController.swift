//
//  NewFeatureCollectionViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/14.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit


class NewFeatureCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        flowLayout.itemSize = view.frame.size
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 /// 设置布局
    
    
    
    
    
    /// 图片总数
    let imageNumber = 4
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return imageNumber
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewFeatureCell", forIndexPath: indexPath) as! NewFeatureCollectionViewCell
        cell.imageIndex = indexPath.item
        
    
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let path = collectionView.indexPathsForVisibleItems().last as! NSIndexPath
        if path.item == imageNumber - 1 {
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCollectionViewCell
            cell.showStartButton()
                    }
        
    }
  
    //: 懒加载数组怎么搞
//    lazy var images: NSArray? = {
//        let imageNumber = 4
//        let array = NSMutableArray()
//        for var i = 0 ; i< imageNumber ;i++ {
//            let imgString = "new_feature_" + \(i)
//        
//        }
//        return array
//    }()

}

class NewFeatureCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func showStartClick() {
       // println(__FUNCTION__)
        NSNotificationCenter.defaultCenter().postNotificationName(WCSwitchRootViewControllerNotification, object: "Main")
    }
    
    var imageIndex: Int = 0{
        didSet{
           var imageName = "new_feature_"+"\(imageIndex + 1)"
            imageView.image = UIImage(named:imageName)
            startBtn.hidden = true
        }
    }
    func showStartButton() {
        startBtn.hidden = false
///  设置动画效果
        startBtn.transform = CGAffineTransformMakeScale(0, 0)
        /// duration: 动画时长
        /// delay:     动画延迟多长时间执行
        /// Damping : 弹簧系数 0~1
        /// Velocity : 弹簧起始发力速度
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 15.0, options: nil, animations: { () -> Void in
           self.startBtn.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }) { (_) -> Void in
            println("动画完成")
        }
    }
}
