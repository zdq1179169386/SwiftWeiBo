//
//  UIButton-Extension.swift
//  WeiBo
//
//  Created by yb on 16/9/19.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

extension UIButton {
    
    ///扩展类方法
    class func creatBtn (_ image : String, bgImage : String) -> UIButton {
        
        let btn = UIButton.init()
        
        btn.setBackgroundImage(UIImage.init(named: bgImage), for: UIControlState())
        btn.setBackgroundImage(UIImage.init(named: bgImage + "_highlighted"), for: .highlighted)
        btn.setImage(UIImage.init(named: image), for: UIControlState())
        btn.setImage(UIImage.init(named: image + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        return btn
        
    }
///    便利构造函数
    convenience init(image : String, bgImage : String ){
        self.init()
        self.setBackgroundImage(UIImage.init(named: bgImage), for: UIControlState())
        self.setBackgroundImage(UIImage.init(named: bgImage + "_highlighted"), for: .highlighted)
        self.setImage(UIImage.init(named: image), for: UIControlState())
        self.setImage(UIImage.init(named: image + "_highlighted"), for: .highlighted)
        self.sizeToFit()
    }
    

}
