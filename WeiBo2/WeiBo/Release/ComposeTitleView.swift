//
//  ComposeTitleView.swift
//  WeiBo
//
//  Created by yb on 16/9/27.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {
    
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var nameLabel : UILabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ComposeTitleView{
    private func setupUI(){
    
        addSubview(titleLabel)
        addSubview(nameLabel)
        
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFontOfSize(16)
        nameLabel.font = UIFont.systemFontOfSize(14)
        nameLabel.textColor = UIColor.lightGrayColor()
        
        titleLabel.text = "发微博"
        nameLabel.text = OAuthUserTool.shareInstance.account?.screen_name
        
    }
}
