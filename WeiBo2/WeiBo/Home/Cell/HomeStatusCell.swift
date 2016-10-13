//
//  HomeStatusCell.swift
//  WeiBo
//
//  Created by yb on 16/9/23.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel

private let Margin : CGFloat = 15
private let ItemMargin : CGFloat = 10

@objc protocol HomeStatusCellDelegate: NSObjectProtocol {
    
    @objc optional func HomeStatusCellTextClick(text : String,range : NSRange)
}

class HomeStatusCell: UITableViewCell {
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verfiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var creatTime: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: HYLabel!
    @IBOutlet weak var picView: PicCollectionView!//配图view
    @IBOutlet weak var retweetedContentLabel: HYLabel!
    @IBOutlet weak var retweentedBGView: UIView!
    
    //collectionView的宽高约束
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var contentLabelRightCons: NSLayoutConstraint!
    @IBOutlet weak var retweentedContentTopCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
    private lazy var manager : EmoticonManager = EmoticonManager()
    
    var deleggate : HomeStatusCellDelegate?
    
    
    var viewModel : StatusViewModel? {
        
        
        
        didSet{
            guard let viewModel = viewModel else{
                return
            }
//            print("---\(viewModel.status?.user?.screen_name),\(viewModel.status?.text),\(viewModel.status?.retweeted_status?.text)")
            //设置头像
            iconView.sd_setImageWithURL(viewModel.iconURL, placeholderImage: UIImage.init(named: "avatar_default_small") )
            //设置认证图标
            verfiedView.image = viewModel.verifiedImage
            //设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.orangeColor() : UIColor.blackColor()
            //vip
            vipView.image = viewModel.vipImage
            //来源
            sourceLabel.text =  viewModel.sourceText
            //创建时间
            creatTime.text = viewModel.createText
            //正文
            
            contentLabel.attributedText = FindEmoticon.shareInstance.findAttrString(viewModel.status?.text, font: contentLabel.font)
            
            //根据配图的count计算配图的宽高
            let picViewSize = self.calculatePicViewSize(viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            //给 picView 设置数据
            picView.picURLs = viewModel.picURLs
            
            //设置转发微博正文
            if viewModel.status?.retweeted_status != nil {
                if let screenNmae = viewModel.status?.retweeted_status?.user?.screen_name , let retweentedText = viewModel.status?.retweeted_status?.text {
                    //设置转发微博正文
                    let text = "@\(screenNmae): " + retweentedText
                    retweetedContentLabel.attributedText = FindEmoticon.shareInstance.findAttrString(text, font: retweetedContentLabel.font)
                    //设置转发背景的隐藏
                    retweentedBGView.hidden = false
                    //设置转发微博正文top约束
                    retweentedContentTopCons.constant = 15
                    
                }
            }else{
                
                retweetedContentLabel.text = nil
                //设置转发背景的隐藏
                retweentedBGView.hidden = true
                //设置转发微博正文top约束
                retweentedContentTopCons.constant = 0

        
            }
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentLabelRightCons.constant = Margin
//        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * Margin
        

        // 监听HYlabel内容的点击
        // 监听@谁谁谁的点击
        contentLabel.userTapHandler = { (label, user, range) in
            

            self.deleggate?.HomeStatusCellTextClick!(user, range: range)
            print(user)
            print(range)
        }
        
        // 监听链接的点击
        contentLabel.linkTapHandler = { (label, link, range) in
            self.deleggate?.HomeStatusCellTextClick!(link, range: range)

            print(link)
            print(range)
        }
        
        // 监听话题的点击
        contentLabel.topicTapHandler = { (label, topic, range) in
            self.deleggate?.HomeStatusCellTextClick!(topic, range: range)

            print(topic)
            print(range)
        }

        
        retweetedContentLabel.userTapHandler = { (label, user, range) in
            self.deleggate?.HomeStatusCellTextClick!(user, range: range)

            print(user)
            print(range)
        }
        
        // 监听链接的点击
        retweetedContentLabel.linkTapHandler = { (label, link, range) in
            self.deleggate?.HomeStatusCellTextClick!(link, range: range)

            print(link)
            print(range)
        }
        
        // 监听话题的点击
        retweetedContentLabel.topicTapHandler = { (label, topic, range) in
            self.deleggate?.HomeStatusCellTextClick!(topic, range: range)
            print(topic)
            print(range)
        }
        
    }
    
    
}
//MARK:- 根据配图的count计算配图的宽高
extension HomeStatusCell {
    private func calculatePicViewSize(count : Int) -> CGSize{
        //没有配图
        if count == 0 {
            //没有配图是picView底部的约束设置为0
            picViewBottomCons.constant = 0
            return CGSizeZero
        }
        //有配图的话底部约束为10
        picViewBottomCons.constant = 10

        //设置collectionView 的item的 size
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout

        
        if count == 1 {
            //String!不管你传什么过来，都强制解包
            let urlStr = viewModel?.picURLs.last?.absoluteString
            
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlStr)
            //设置item的大小
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            //返回collectionView的大小
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
            
        }
        
        //4张配图
        let itemWH = (UIScreen.mainScreen().bounds.width - 2 * Margin - 2 * ItemMargin) / 3
         //设置item的大小
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        if count == 4 {
            //这里计算约束必须得加一，不然会有bug
            let picViewWH = itemWH * 2 + ItemMargin + 1
            return CGSizeMake(picViewWH, picViewWH)
            
        }
        //其他
        let rows = CGFloat((count - 1) / 3 + 1)
        
        let picViewH = rows * itemWH + (rows - 1) * ItemMargin
        
        let picViewW = UIScreen.mainScreen().bounds.width - 2 * Margin
        
        return CGSize(width: picViewW, height: picViewH)

    }
}


