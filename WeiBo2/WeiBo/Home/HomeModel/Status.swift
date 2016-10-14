//
//  Status.swift
//  WeiBo
//
//  Created by yb on 16/9/22.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class Status: NSObject {
    ///微博创建时间
    var created_at : String?
    ///微博来源
    var source : String?
    ///微博正文
    var text : String?
    ///微博ID
    var mid : Int = 0
    ///用户模型
    var user : User?
    ///微博配图
    var pic_urls :[[String : String]]?
    ///转发微博
    var retweeted_status : Status?
    
    
    
    
    
    //自定义构造函数
    init(dict : [ String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        if let userDict = dict["user"] as? [String : AnyObject] {
            
            user = User.init(dict: userDict)
        }
        //将转发微博字典转成用户模型
        if let retweetedDisct = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = Status.init(dict: retweetedDisct)
        }
        
    }
    //重写setValueforUndefinedKey方法，防止因为key不存在而崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }

}
