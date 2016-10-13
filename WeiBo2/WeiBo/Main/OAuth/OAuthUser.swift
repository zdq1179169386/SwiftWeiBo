//
//  OAuthUser.swift
//  WeiBo
//
//  Created by yb on 16/9/21.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class OAuthUser: NSObject ,NSCoding{
    
    var access_token : String?
    
    var uid : String?
    
    var expires_in : NSTimeInterval = 0.0{
        
        didSet{
            expires_date = NSDate.init(timeIntervalSinceNow: expires_in)
        }
    }
    var  expires_date : NSDate?
    
    var screen_name : String?
    
    var avatar_large : String?
    
    
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    override var description: String{
        
        return dictionaryWithValuesForKeys(["access_token","uid","expires_in","expires_date","screen_name","avatar_large"]).description
    }
    
    //解档
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String

    }
    //归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")

    }
    

}
