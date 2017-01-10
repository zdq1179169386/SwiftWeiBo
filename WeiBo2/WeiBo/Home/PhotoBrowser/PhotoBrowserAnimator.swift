//
//  PhotoBrowserAnimator.swift
//  WeiBo
//
//  Created by yb on 16/10/12.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

//面向协议
@objc protocol AnimatorPresentedDelegate: NSObjectProtocol {
    
   @objc optional func startRect(_ indexPath : IndexPath) -> CGRect
   @objc optional func endRect(_ indexPath : IndexPath) -> CGRect
   @objc optional func imageView(_ indexPath : IndexPath) -> UIImageView
}

@objc protocol AnimatorDismissDelegate {
   @objc optional func indexPathForDismissView() -> IndexPath
   @objc optional func imageViewForDismissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    
    var isPresented : Bool = false
    
    //设置代理属性
    var presentedDelegate : AnimatorPresentedDelegate?
    var indexPath : IndexPath?
    var dismissDelegate : AnimatorDismissDelegate?
    
    
}


extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate{
    

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //return 的控制器必须遵守 UIViewControllerAnimatedTransitioning 协议
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning{
    //动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    //动画方式
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    //弹出动画
    func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning){
        
        guard let presentedDelegate = presentedDelegate,let indexPath = indexPath else{
            return
        }
        //取出弹出view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        transitionContext.containerView.addSubview(presentedView)
        
        //调用协议方法
        let startF = presentedDelegate.startRect!(indexPath)
        
        let imgView = presentedDelegate.imageView!(indexPath)
        transitionContext.containerView.addSubview(imgView)

        imgView.frame = startF
        
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imgView.frame = presentedDelegate.endRect!(indexPath)
            
            }, completion: { (_) in
             
                imgView.removeFromSuperview()
                presentedView.alpha = 1.0
                transitionContext.containerView.backgroundColor = UIColor.clear
                transitionContext.completeTransition(true)
        }) 
        
    }
    //消失动画
    func animationForDismissView(_ transitionContext: UIViewControllerContextTransitioning){
        
        guard let presentedDelegate = presentedDelegate, let dismissDelegate = dismissDelegate else{
            return
        }
        
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        let imgView = dismissDelegate.imageViewForDismissView!()
        transitionContext.containerView.addSubview(imgView)
        let indexPath = dismissDelegate.indexPathForDismissView!()
        dismissView.removeFromSuperview()

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imgView.frame = presentedDelegate.startRect!(indexPath)
            
            }, completion: { (_) in
                transitionContext.completeTransition(true)
        }) 
        
        
        
    }
}
