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
    class func creatBtn (image : String, bgImage : String) -> UIButton {
        
        let btn = UIButton.init()
        
        btn.setBackgroundImage(UIImage.init(named: bgImage), forState: .Normal)
        btn.setBackgroundImage(UIImage.init(named: bgImage + "_highlighted"), forState: .Highlighted)
        btn.setImage(UIImage.init(named: image), forState: .Normal)
        btn.setImage(UIImage.init(named: image + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        
        return btn
        
    }
///    便利构造函数
    convenience init(image : String, bgImage : String ){
        self.init()
        self.setBackgroundImage(UIImage.init(named: bgImage), forState: .Normal)
        self.setBackgroundImage(UIImage.init(named: bgImage + "_highlighted"), forState: .Highlighted)
        self.setImage(UIImage.init(named: image), forState: .Normal)
        self.setImage(UIImage.init(named: image + "_highlighted"), forState: .Highlighted)
        self.sizeToFit()
    }
    

}
