//
//  PicPickerCell.swift
//  WeiBo
//
//  Created by yb on 16/9/28.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    
    
    var image : UIImage? {
        
        didSet {
            
            if image != nil{
                photoView.image = image
                removeBtn.isHidden = false
                addBtn.isUserInteractionEnabled = false
                
            }else{
                
                photoView.image = nil
                removeBtn.isHidden = true
                addBtn.isUserInteractionEnabled = true

            }
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension PicPickerCell {
    //添加图片
    @IBAction func addPhotoClick(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    //删除图片
    @IBAction func removePhotoClick(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: PicPickerRemovePhotoNote), object: photoView.image)

    }
}
