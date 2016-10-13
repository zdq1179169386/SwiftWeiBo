//
//  TitleButton.swift
//  WeiBo
//
//  Created by yb on 16/9/20.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame:frame)
        setImage(UIImage.init(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), forState: .Selected)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        sizeToFit()
    }
    
    //swift 中重写控件的init(frame) 方法 或 init()方法，必须重写init?(coder) 方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //重新设置titleLabel和imageView的坐标
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }

}
