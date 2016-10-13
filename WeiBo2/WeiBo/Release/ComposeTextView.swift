




//
//  ComposeTextView.swift
//  WeiBo
//
//  Created by yb on 16/9/27.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    
    lazy var placeHolder : UILabel = UILabel()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        font = UIFont.systemFontOfSize(18)
        setupUI()
    }

}

extension ComposeTextView{
    private func setupUI(){
    
        addSubview(placeHolder)
        
        placeHolder.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        placeHolder.textColor = UIColor.lightGrayColor()
        placeHolder.font = font
        placeHolder.text = "分享新鲜事..."
        textContainerInset = UIEdgeInsets.init(top: 6, left: 7, bottom: 0, right: 7)
    }
}
