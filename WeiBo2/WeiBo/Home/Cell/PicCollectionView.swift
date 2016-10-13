

//
//  PicCollectionView.swift
//  WeiBo
//
//  Created by yb on 16/9/24.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SDWebImage
class PicCollectionView: UICollectionView {

    //给PicCollectionView设置数据时刷新表
    var picURLs : [NSURL] = [NSURL](){
        didSet {
            self.reloadData()
        }
    }
    

    override func awakeFromNib() {
        dataSource = self
        delegate = self
    }

}
//MARK:- UICollectionViewDataSource
extension PicCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicViewCell", forIndexPath: indexPath) as! PicViewCell
        
//        cell.backgroundColor = UIColor.redColor()
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let userInfo = [ShowPhotoBrowserIndexKey:indexPath,ShowPhotoBrowserUrlKey: picURLs];
        
        //发送通知
        //这里把self(PicCollectionView) 传到 HomeViewController，然后设置 PicCollectionView 成为 PopoverAnimator 的 presentedDelegate 的代理，实现了从 PicCollectionView 到 PopoverAnimator 之间的传值
        NSNotificationCenter.defaultCenter().postNotificationName(ShowPhotoBrowserNote, object: self, userInfo: userInfo)
    }
    
}
//MARK:- 实现代理方法 AnimatorPresentedDelegate
extension PicCollectionView : AnimatorPresentedDelegate{
    // 将起始的frame 传到 PhotoBrowserAnimator 中，进行动画
    func startRect(indexPath : NSIndexPath) -> CGRect{
        
        let cell = self.cellForItemAtIndexPath(indexPath)!
        //获取cell 在window上的 位置
        let rect = self.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return rect
    }
    
    func endRect(indexPath : NSIndexPath) -> CGRect{
        
        let picURL = picURLs[indexPath.item]
        
        let img = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        
        let w = UIScreen.mainScreen().bounds.width
        let h = w / img.size.width * img.size.height
        var y : CGFloat = 0
        if y > UIScreen.mainScreen().bounds.height {
            //长图文
            y = 0
        }else{
            y = (UIScreen.mainScreen().bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
        
    }
    func imageView(indexPath : NSIndexPath) -> UIImageView{
        //创建新的UIImageView 来进行动画
        let imgView = UIImageView()
        
        let picURL = picURLs[indexPath.item]
        let img = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        
        imgView.image = img
        imgView.contentMode = .ScaleToFill
        imgView.clipsToBounds = true
        
        return imgView
    }
    
}

//MARK:- PicViewCell
class PicViewCell: UICollectionViewCell {
    
    var picURL : NSURL? {
    
        didSet{
            guard let picURL = picURL else{
                return
            }
            iconView.sd_setImageWithURL(picURL, placeholderImage: UIImage.init(named: "empty_picture"))
        }
    }
    
    
    @IBOutlet weak var iconView: UIImageView!
    
}

