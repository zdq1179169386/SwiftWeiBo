

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
    var picURLs : [URL] = [URL](){
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicViewCell", for: indexPath) as! PicViewCell
        
//        cell.backgroundColor = UIColor.redColor()
        
        cell.picURL = picURLs[(indexPath as NSIndexPath).item]
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userInfo = [ShowPhotoBrowserIndexKey:indexPath,ShowPhotoBrowserUrlKey: picURLs] as [String : Any];
        
        //发送通知
        //这里把self(PicCollectionView) 传到 HomeViewController，然后设置 PicCollectionView 成为 PopoverAnimator 的 presentedDelegate 的代理，实现了从 PicCollectionView 到 PopoverAnimator 之间的传值
        NotificationCenter.default.post(name: Notification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
    }
    
}
//MARK:- 实现代理方法 AnimatorPresentedDelegate
extension PicCollectionView : AnimatorPresentedDelegate{
    // 将起始的frame 传到 PhotoBrowserAnimator 中，进行动画
    func startRect(_ indexPath : IndexPath) -> CGRect{
        
        let cell = self.cellForItem(at: indexPath)!
        //获取cell 在window上的 位置
        let rect = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        
        return rect
    }
    
    func endRect(_ indexPath : IndexPath) -> CGRect{
        
        let picURL = picURLs[(indexPath as NSIndexPath).item]
        
        let img = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        let w = UIScreen.main.bounds.width
        let h = w / (img?.size.width)! * (img?.size.height)!
        var y : CGFloat = 0
        if y > UIScreen.main.bounds.height {
            //长图文
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
        
    }
    func imageView(_ indexPath : IndexPath) -> UIImageView{
        //创建新的UIImageView 来进行动画
        let imgView = UIImageView()
        
        let picURL = picURLs[(indexPath as NSIndexPath).item]
        let img = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        imgView.image = img
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        
        return imgView
    }
    
}

//MARK:- PicViewCell
class PicViewCell: UICollectionViewCell {
    
    var picURL : URL? {
    
        didSet{
            guard let picURL = picURL else{
                return
            }
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage.init(named: "empty_picture"))
        }
    }
    
    
    @IBOutlet weak var iconView: UIImageView!
    
}

