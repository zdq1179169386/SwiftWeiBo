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
    
    var picURL : URL?{
        
        didSet{
        
            setupContent(picURL)
        }
    }
    
    var delegate : PhotoBrowserViewCellDelegate?
    
    
    //懒加载
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    fileprivate lazy var progressView : ProgressView = ProgressView()
    
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoBrowserViewCell {
  
    fileprivate func setupUI(){
     
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoBrowserViewCell.imageClick))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
    }
}
extension PhotoBrowserViewCell{
    
    @objc fileprivate func imageClick(){
        
        delegate?.imageClick()
        
    }
}

extension PhotoBrowserViewCell{
   
    fileprivate func setupContent(_ picURL : URL?){
        
        guard let picURL = picURL else{
            return
        }
        
        let img = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        let width = UIScreen.main.bounds.width
        
        let height = width / (img?.size.width)! * (img?.size.height)!
        var y : CGFloat = 0
        //长图文
        if height > UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigURL(picURL), placeholderImage: img, options: [], progress: { (current, total) in
            
            self.progressView.progress = CGFloat(current) / CGFloat(total)
            
            }) { (_, _, _, _) in
                self.progressView.isHidden = true
        }
        //
        scrollView.contentSize = CGSize(width: 0, height: height)
    
    }
    
    fileprivate func getBigURL(_ smallURL : URL) -> URL{
        
        let smallStr = smallURL.absoluteString
        let bigStr = smallStr.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL.init(string: bigStr)!
    }
}
