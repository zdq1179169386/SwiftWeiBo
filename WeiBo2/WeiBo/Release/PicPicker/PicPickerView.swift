

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
        register(UINib.init(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: PicPicker)
        self.backgroundColor = UIColor.lightGray
        
        //设置item的大小
    
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (UIScreen.main.bounds.width - 40)/3
        
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }

}


extension PicPickerView : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicPicker, for: indexPath) as! PicPickerCell
        
        cell.backgroundColor = UIColor.clear
        
        cell.image = (indexPath as NSIndexPath).item < images.count ? images[(indexPath as NSIndexPath).item] : nil
        
        return cell
    }

}
