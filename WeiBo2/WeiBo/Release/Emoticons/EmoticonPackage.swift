//
//  EmoticonPackage.swift
//  WeiBo
//
//  Created by yb on 16/9/29.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    
    var emoticons : [Emoticon] = [Emoticon]()
    
    
    init(id : String) {
        super.init()
        //最近
        if id == "" {
            addEmptyEmoticon(true)
            return
        }
        
        let plistPath = NSBundle.mainBundle().pathForResource("\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        let array = NSArray.init(contentsOfFile: plistPath) as! [[String : String]]
        
        var index = 0
        for var dict in array {
           
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            
            emoticons.append(Emoticon.init(dict: dict))
            
            index++
            //每二十个加一个删除按钮
            if index == 20 {
                emoticons.append(Emoticon.init(isRemove: true))
                index = 0
            }
            
        }
        //最后加空白按钮
        addEmptyEmoticon(false)
    }
    
    private func addEmptyEmoticon(isRecently : Bool){
        let count = emoticons.count % 21 //求余
        
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon.init(isEmpty: true))
        }
        emoticons.append(Emoticon.init(isRemove: true))
    }

}
