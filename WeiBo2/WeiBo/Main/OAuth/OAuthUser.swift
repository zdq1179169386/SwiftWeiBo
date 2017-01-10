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
    
    var expires_in : TimeInterval = 0.0{
        
        didSet{
            expires_date = Date.init(timeIntervalSinceNow: expires_in)
        }
    }
    var  expires_date : Date?
    
    var screen_name : String?
    
    var avatar_large : String?
    
    
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    override var description: String{
        
        return dictionaryWithValues(forKeys: ["access_token","uid","expires_in","expires_date","screen_name","avatar_large"]).description
    }
    
    //解档
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String

    }
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")

    }
    

}
