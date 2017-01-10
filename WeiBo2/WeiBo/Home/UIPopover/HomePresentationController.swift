//
//  HomePresentationController.swift
//  WeiBo
//
//  Created by yb on 16/9/20.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class HomePresentationController: UIPresentationController {
    
    var presentedFrame : CGRect = CGRect.zero
    
    ///蒙版View
    fileprivate lazy var coverView : UIView = {
        
        let view = UIView.init()
        view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.2)
        return view
    }()
    //重写containerViewWillLayoutSubviews，设置弹出view的尺寸
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //设置弹出view的尺寸
        presentedView?.frame = presentedFrame
        
        //添加蒙版
        self.setupUI()
    }
    
    

}
//MARK:- 设置UI
extension HomePresentationController {
    
    fileprivate func setupUI(){
        containerView?.insertSubview(coverView, at: 0)
        
        coverView.frame = (containerView?.bounds)!
        //添加点击手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(HomePresentationController.coverViewTap))
        coverView.addGestureRecognizer(tap)
        
    }

}

//MARK:- 点击事件
extension HomePresentationController {

    @objc fileprivate func coverViewTap(){
        //拿到弹出控制器
        presentedViewController.dismiss(animated: true, completion: nil)
        print("coverViewTap")
    }

}
