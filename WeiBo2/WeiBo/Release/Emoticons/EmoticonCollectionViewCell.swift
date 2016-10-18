


//
//  EmoticonCollectionViewCell.swift
//  WeiBo
//
//  Created by yb on 16/9/29.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class EmoticonCollectionViewCell: UICollectionViewCell {
    
    private lazy var btn : UIButton = UIButton()
    
    var emoticon : Emoticon?{
        
        didSet {
            guard let emoticon = emoticon else{
                return
            }
            
            btn.setImage(UIImage.init(contentsOfFile: emoticon.pngPath ?? ""), forState: .Normal)
            btn.setTitle(emoticon.emojiCode, forState: .Normal)
            
            if emoticon.isRemove{
                btn.setImage(UIImage.init(named: "compose_emotion_delete"), forState: .Normal)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(btn)
        btn.frame = contentView.bounds
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        btn.userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
