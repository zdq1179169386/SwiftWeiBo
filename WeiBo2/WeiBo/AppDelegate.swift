//
//  AppDelegate.swift
//  WeiBo
//
//  Created by yb on 16/9/18.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var defaultVC : UIViewController{
        let isLogin = OAuthUserTool.shareInstance.isLogin
        
        return isLogin ? WelcomeViewController() : UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
        
    }
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultVC
        window?.makeKeyAndVisible()

        return true
    }

    
}

