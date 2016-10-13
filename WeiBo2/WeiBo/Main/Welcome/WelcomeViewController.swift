//
//  WelcomeViewController.swift
//  WeiBo
//
//  Created by yb on 16/9/22.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconStr = OAuthUserTool.shareInstance.account?.avatar_large
        let iconUrl = NSURL.init(string: iconStr ?? "")
        iconView.sd_setImageWithURL(iconUrl, placeholderImage: UIImage.init(named: "avatar_default_big"))
        iconBottomConstraint.constant = UIScreen.mainScreen().bounds.size.height - 250
        //Damping：阻力系数，阻力系数越大弹动效果越不明显
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
                //欢迎界面结束，显示主控制器
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }

    }

}
