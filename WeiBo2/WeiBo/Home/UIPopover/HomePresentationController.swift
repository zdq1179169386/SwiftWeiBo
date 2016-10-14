//
//  HomePresentationController.swift
//  WeiBo
//
//  Created by yb on 16/9/20.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class HomePresentationController: UIPresentationController {
    
    var presentedFrame : CGRect = CGRectZero
    
    ///蒙版View
    private lazy var coverView : UIView = {
        
        let view = UIView.init()
        view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.2)
        return view
    }()
    //重写containerViewWillLayoutSubviews，设置弹出view的尺寸
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //设置弹出view的尺寸
        presentedView()?.frame = presentedFrame
        
        //添加蒙版
        self.setupUI()
    }
    
    

}
//MARK:- 设置UI
extension HomePresentationController {
    
    private func setupUI(){
        containerView?.insertSubview(coverView, atIndex: 0)
        
        coverView.frame = (containerView?.bounds)!
        //添加点击手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(HomePresentationController.coverViewTap))
        coverView.addGestureRecognizer(tap)
        
    }

}

//MARK:- 点击事件
extension HomePresentationController {

    @objc private func coverViewTap(){
        //拿到弹出控制器
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        print("coverViewTap")
    }

}
