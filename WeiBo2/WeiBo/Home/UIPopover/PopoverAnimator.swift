

//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by yb on 16/9/21.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    var presentedFrame : CGRect = CGRect.zero
    
    var callBack : ((_ presented : Bool) -> ())?
    

    //区分消失还是弹出动画
     var isPresented : Bool = false
    
    //自定义构造函数，如果没有重写默认的构造函数init(),系统会覆盖掉默认构造函数init(),如果不想覆盖掉，必须重写init()方法
    init(callBack : @escaping (_ presented : Bool) -> ()) {
        
        print("callBack")
        self.callBack = callBack
    }
}

//MARK:- 转场动画协议
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        let presentedVC = HomePresentationController.init(presentedViewController: presented, presenting: presenting)
        presentedVC.presentedFrame = presentedFrame
        return presentedVC
    }
    //自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    //自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        return self
    }
    
}



extension PopoverAnimator : UIViewControllerAnimatedTransitioning{
    
    //动画的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5
    }
    
    //transitionContext： 动画上下文
    //    UITransitionContextToViewKey:获取弹出的view
    //    UITransitionContextFromViewKey：获取消失的view
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
        
    }
    
    //自定义弹出动画
    fileprivate func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning){
        
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        transitionContext.containerView.addSubview(presentedView)
        
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        //不设置锚点，动画会从中间开始
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            presentedView.transform = CGAffineTransform.identity
        }, completion: { (_) in
            //必须告诉上下文已经完成动画
            transitionContext.completeTransition(true)
        }) 
        
    }
    //自定义消失动画
    fileprivate func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning){
        //拿到消失的view
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            //这里sy如果设置为0.0，动画时间会很快
            dismissedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0000001)
        }, completion: { (_) in
            dismissedView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }) 
        
    }
}
