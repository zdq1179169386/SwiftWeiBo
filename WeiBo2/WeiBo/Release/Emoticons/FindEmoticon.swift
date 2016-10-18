//
//  FindEmoticon.swift
//  WeiBo
//
//  Created by yb on 16/10/11.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    
    static let shareInstance : FindEmoticon = FindEmoticon()
    
    private lazy var manager : EmoticonManager = EmoticonManager()
    
    func findAttrString(text : String? ,font : UIFont) -> NSMutableAttributedString?{
        
        guard let text = text else{
            return nil
        }
        //[]在正则中有特殊含义，所以要加\，而\在swift中又有特殊含义，所以再加一个\
        //.任意字符，*任意个数  ?到问号后面的字符位置
        let pattern = "\\[.*?\\]"
        
        guard  let regex = try? NSRegularExpression(pattern: pattern, options: []) else{
            return nil
        }
        let range = NSRange(location: 0, length: text.characters.count)
        
        let results = regex.matchesInString(text, options: [], range: range)
        
        let attrMStr = NSMutableAttributedString(string: text)
        
        for var i = results.count - 1 ; i >= 0 ; i = i-1 {
            let result = results[i];
            
            let chs = (text as NSString).substringWithRange(result.range)
            
            guard let pngPath = findPngPath(chs) else{
//当碰上 [二哈] 这样的，而本地找不到表情替换时，不能返回nil，因为这样微博正文会为空，从而导致空白
                
                return NSMutableAttributedString.init(string: text)
            }
            let attachment = NSTextAttachment()
            attachment.image = UIImage.init(contentsOfFile: pngPath)
            attachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight)
            
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            attrMStr.replaceCharactersInRange(result.range, withAttributedString: attrImageStr)
        }
        
        return attrMStr
    }
    
    private func findPngPath(chs : String) -> String?{
        
        for package in manager.packages {
            
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }


}
