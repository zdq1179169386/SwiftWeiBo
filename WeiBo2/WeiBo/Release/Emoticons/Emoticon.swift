//
//  Emoticon.swift
//  WeiBo
//
//  Created by yb on 16/9/29.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    //emoji的code
    var code : String?{
        didSet {
            guard let code = code else{
                return
            }
            //创建saomiaoqi
            let scanner = Scanner(string: code)
            //扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            //将value转成字符
            let c = Character.init(UnicodeScalar.init(value)!)
            
            //将字符转成字符串
            emojiCode = String(c)
            
        }
    }
    
    var png : String? {
        didSet {
            guard let png = png else{
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs : String?
    
    //数据处理
    var pngPath : String?
    var emojiCode : String?
    var isEmpty : Bool = false
    var isRemove : Bool = false

    
    //自定义构造函数

    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    init(isEmpty : Bool) {
        super.init()
        self.isEmpty = isEmpty
    }
    init(isRemove : Bool) {
        super.init()
        self.isRemove = isRemove
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    

    override var description: String{
        return dictionaryWithValues(forKeys: ["pngPath","emojiCode","chs"]).description
    }
}
