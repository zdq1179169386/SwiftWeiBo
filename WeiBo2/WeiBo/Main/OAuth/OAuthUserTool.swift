


//
//  OAuthUserTool.swift
//  WeiBo
//
//  Created by yb on 16/9/22.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class OAuthUserTool: NSObject {
    
    //单例
    static let shareInstance : OAuthUserTool = OAuthUserTool.init()
    
    //user
    var account : OAuthUser?
    
    ///计算属性
    var accountPath : String{
        
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        return (accountPath as NSString).stringByAppendingPathComponent("account.plist")
    }
    
   
     ///计算属性,是否登录
    var isLogin : Bool {
//        print("isLogin = \(account?.expires_date)")
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else{
            return false
        }
        
        return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
    
    override init() {
        super.init()
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? OAuthUser
//        print("init = \(account)")
        
    }
    

}
