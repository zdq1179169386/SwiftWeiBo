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
    
   @objc optional func startRect(indexPath : NSIndexPath) -> CGRect
   @objc optional func endRect(indexPath : NSIndexPath) -> CGRect
   @objc optional func imageView(indexPath : NSIndexPath) -> UIImageView
}

@objc protocol AnimatorDismissDelegate {
   @objc optional func indexPathForDismissView() -> NSIndexPath
   @objc optional func imageViewForDismissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    
    var isPresented : Bool = false
    
    //设置代理属性
    var presentedDelegate : AnimatorPresentedDelegate?
    var indexPath : NSIndexPath?
    var dismissDelegate : AnimatorDismissDelegate?
    
    
}


extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate{
    

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //return 的控制器必须遵守 UIViewControllerAnimatedTransitioning 协议
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning{
    //动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    //动画方式
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    //弹出动画
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        
        guard let presentedDelegate = presentedDelegate,indexPath = indexPath else{
            return
        }
        //取出弹出view
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        transitionContext.containerView()?.addSubview(presentedView)
        
        //调用协议方法
        let startF = presentedDelegate.startRect!(indexPath)
        
        let imgView = presentedDelegate.imageView!(indexPath)
        transitionContext.containerView()?.addSubview(imgView)

        imgView.frame = startF
        
        presentedView.alpha = 0.0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()

        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            imgView.frame = presentedDelegate.endRect!(indexPath)
            
            }) { (_) in
             
                imgView.removeFromSuperview()
                presentedView.alpha = 1.0
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
        }
        
    }
    //消失动画
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){
        
        guard let presentedDelegate = presentedDelegate, dismissDelegate = dismissDelegate else{
            return
        }
        
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        let imgView = dismissDelegate.imageViewForDismissView!()
        transitionContext.containerView()?.addSubview(imgView)
        let indexPath = dismissDelegate.indexPathForDismissView!()
        dismissView.removeFromSuperview()

        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            imgView.frame = presentedDelegate.startRect!(indexPath)
            
            }) { (_) in
                transitionContext.completeTransition(true)
        }
        
        
        
    }
}