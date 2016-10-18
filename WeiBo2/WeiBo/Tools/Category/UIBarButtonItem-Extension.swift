

//
//  UIBarButtonItem-Extension.swift
//  WeiBo
//
//  Created by yb on 16/9/20.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
   /* 第1种
     convenience init(image : String) {
        self.init()
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: image), forState: .Normal)
        btn.setImage(UIImage.init(named: image + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        self.customView = btn
    }*/
    
    // 第2种
    convenience init(image : String) {
      
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: image), forState: .Normal)
        btn.setImage(UIImage.init(named: image + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        self.init(customView:btn)
    }


}
