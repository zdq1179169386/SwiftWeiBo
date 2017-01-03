

//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by yb on 16/9/21.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    var presentedFrame : CGRect = CGRectZero
    
    var callBack : ((presented : Bool) -> ())?
    

    //区分消失还是弹出动画
     var isPresented : Bool = false
    
    //自定义构造函数，如果没有重写默认的构造函数init(),系统会覆盖掉默认构造函数init(),如果不想覆盖掉，必须重写init()方法
    init(callBack : (presented : Bool) -> ()) {
        
        print("callBack")
        self.callBack = callBack
    }
}

//MARK:- 转场动画协议
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        let presentedVC = HomePresentationController.init(presentedViewController: presented, presentingViewController: presenting)
        presentedVC.presentedFrame = presentedFrame
        return presentedVC
    }
    //自定义弹出动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = true
        callBack!(presented:isPresented)
        return self
    }
    
    //自定义消失动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(presented:isPresented)
        return self
    }
    
}



extension PopoverAnimator : UIViewControllerAnimatedTransitioning{
    
    //动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
    }
    
    //transitionContext： 动画上下文
    //    UITransitionContextToViewKey:获取弹出的view
    //    UITransitionContextFromViewKey：获取消失的view
    
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
        
    }
    
    //自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        transitionContext.containerView()?.addSubview(presentedView)
        
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        //不设置锚点，动画会从中间开始
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            presentedView.transform = CGAffineTransformIdentity
        }) { (_) in
            //必须告诉上下文已经完成动画
            transitionContext.completeTransition(true)
        }
        
    }
    //自定义消失动画
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning){
        //拿到消失的view
        let dismissedView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            //这里sy如果设置为0.0，动画时间会很快
            dismissedView?.transform = CGAffineTransformMakeScale(1.0, 0.0000001)
        }) { (_) in
            dismissedView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
}
