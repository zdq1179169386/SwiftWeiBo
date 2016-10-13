//
//  MainTabViewController.swift
//  WeiBo
//
//  Created by yb on 16/9/18.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    ///懒加载
    private lazy var composeBtn : UIButton = {
//       let btn = UIButton.creatBtn("tabbar_compose_icon_add", bgImage: "tabbar_compose_button")
        let btn = UIButton.init(image: "tabbar_compose_icon_add", bgImage: "tabbar_compose_button")
        btn.center = CGPointMake(self.tabBar.center.x, self.tabBar.bounds.size.height * 0.5)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
 
}

extension MainTabViewController {
    

//    MARK:- 设置UI
    private func setupUI(){
        self.tabBar.addSubview(composeBtn)
        self.composeBtn.addTarget(self, action: #selector(MainTabViewController.click), forControlEvents: .TouchUpInside)
        self.tabBar.tintColor = UIColor.orangeColor()
    }
}

extension MainTabViewController {
//    如果swift中将一个函数添加private，那么该函数不会被添加到方法列表中
//    如果在private前加上@objc ，那么该方法依然会被添加到方法列表中
    @objc private func click(){

        let vc = ComposeViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
                
    }
}
