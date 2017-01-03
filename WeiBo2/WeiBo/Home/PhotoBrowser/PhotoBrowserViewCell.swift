//
//  PhotoBrowserViewCell.swift
//  WeiBo
//
//  Created by yb on 16/10/12.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate : NSObjectProtocol{

    func imageClick()
    
}

class PhotoBrowserViewCell: UICollectionViewCell {
    
    var picURL : NSURL?{
        
        didSet{
        
            setupContent(picURL)
        }
    }
    
    var delegate : PhotoBrowserViewCellDelegate?
    
    
    //懒加载
    private lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    private lazy var progressView : ProgressView = ProgressView()
    
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoBrowserViewCell {
  
    private func setupUI(){
     
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        
        progressView.bounds = CGRectMake(0, 0, 50, 50)
        progressView.center = CGPointMake(UIScreen.mainScreen().bounds.width * 0.5, UIScreen.mainScreen().bounds.height * 0.5)
        
        progressView.hidden = true
        progressView.backgroundColor = UIColor.clearColor()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoBrowserViewCell.imageClick))
        imageView.addGestureRecognizer(tap)
        imageView.userInteractionEnabled = true
        
    }
}
extension PhotoBrowserViewCell{
    
    @objc private func imageClick(){
        
        delegate?.imageClick()
        
    }
}

extension PhotoBrowserViewCell{
   
    private func setupContent(picURL : NSURL?){
        
        guard let picURL = picURL else{
            return
        }
        
        let img = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        
        let width = UIScreen.mainScreen().bounds.width
        
        let height = width / img.size.width * img.size.height
        var y : CGFloat = 0
        //长图文
        if height > UIScreen.mainScreen().bounds.height {
            y = 0
        }else{
            y = (UIScreen.mainScreen().bounds.height - height) * 0.5
        }
        
        imageView.frame = CGRectMake(0, y, width, height)
        
        progressView.hidden = false
        imageView.sd_setImageWithURL(getBigURL(picURL), placeholderImage: img, options: [], progress: { (current, total) in
            
            self.progressView.progress = CGFloat(current) / CGFloat(total)
            
            }) { (_, _, _, _) in
                self.progressView.hidden = true
        }
        //
        scrollView.contentSize = CGSize(width: 0, height: height)
    
    }
    
    private func getBigURL(smallURL : NSURL) -> NSURL{
        
        let smallStr = smallURL.absoluteString
        let bigStr = smallStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        return NSURL.init(string: bigStr)!
    }
}