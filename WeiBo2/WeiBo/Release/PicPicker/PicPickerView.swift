

//
//  PicPickerView.swift
//  WeiBo
//
//  Created by yb on 16/9/28.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

private let PicPicker = "PicPicker"

class PicPickerView: UICollectionView {
    
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //设置代理,报错是因为代理的两个必须实现的方法没有实现
        dataSource = self
        delegate = self
        //注册cell，UICollectionViewCell.self 获取类名
//        registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: PicPicker)
        registerNib(UINib.init(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: PicPicker)
        self.backgroundColor = UIColor.lightGrayColor()
        
        //设置item的大小
    
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (UIScreen.mainScreen().bounds.width - 40)/3
        
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }

}


extension PicPickerView : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PicPicker, forIndexPath: indexPath) as! PicPickerCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.image = indexPath.item < images.count ? images[indexPath.item] : nil
        
        return cell
    }

}
