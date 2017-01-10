//
//  UITextView-Extension.swift
//  WeiBo
//
//  Created by yb on 16/10/10.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

extension UITextView {
    //获取表情
    func getEmoticonString() -> (String) {
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange.init(location: 0, length: attrMStr.length)
        //遍历整个字符串
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            //取出NSAttachment用chs替换表情
            if  let attachmet = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachmet.chs!)
            }
            
        }
        return attrMStr.string
    }
    
    //插入表情
    func insertEmoticon(_ emoticon : Emoticon) {
        
        //空白表情
        if emoticon.isEmpty {
            return
        }
        //删除按钮
        if emoticon.isRemove {
            
            deleteBackward()
            return
            
        }
        //emoji
        
        if emoticon.emojiCode != nil {
            let range = selectedTextRange!
            replace(range, withText: emoticon.emojiCode!)
            return
        }
        //普通表情
        
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage.init(contentsOfFile: emoticon.pngPath!)
        
        let attrImgStr = NSAttributedString(attachment: attachment)
        //设置表情的大小
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        
        let attMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = selectedRange
        
        attMStr.replaceCharacters(in: range, with: attrImgStr)
        
        attributedText = attMStr
        
        //将文字大小重置
        self.font = font;
        
        //将光标位置重置
        selectedRange = NSRange(location: range.location + 1, length: 0)

    }
}
