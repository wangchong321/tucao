//
//  PictureSelectCollectionViewController.swift
//  WCWeiBo
//
//  Created by 王充 on 15/5/23.
//  Copyright (c) 2015年 wangchong. All rights reserved.
//

import UIKit

class PictureSelectCollectionViewController: UICollectionViewController {
    var pictureList = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        regNotificiton()
    
        }
    // 注册通知
    private func regNotificiton(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectPicture:", name:WCSelectPictureNotifiction , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removePicture:", name: WCRemoviPictureNotifiction, object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func selectPicture(notifiction : NSNotification) {
    
        // 如果已经有图片了,就返回
        let cell = notifiction.object as! PictureCollectionViewCell
        if cell.image != nil {
            println("已经有图片了")
            return
        }
        // 点击图片按钮的时候要进入到系统的图片中
        // 如果不支持图片相册,返回
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            println("不支持相册")
            return
        }
        let picter =  UIImagePickerController()
        picter.delegate = self
        picter.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        picter.allowsEditing = true
        presentViewController(picter, animated: true, completion: nil)
    }
    func removePicture(notifiction : NSNotification) {
        let cell = notifiction.object as! PictureCollectionViewCell
        if let indexP = collectionView?.indexPathForCell(cell){
            pictureList.removeAtIndex(indexP.item)
            collectionView?.reloadData()
        }
        
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return pictureList.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCollectionCell", forIndexPath: indexPath) as! PictureCollectionViewCell
        if indexPath.item < pictureList.count{
        cell.image = pictureList[indexPath.item]
        }else{
            cell.image = nil
        }
    
        return cell
    }

 }
extension PictureSelectCollectionViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        pictureList.append(image.scaleImage(width: 320))
        collectionView?.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
