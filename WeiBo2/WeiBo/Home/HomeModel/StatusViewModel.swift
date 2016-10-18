//
//  StatusViewModel.swift
//  WeiBo
//
//  Created by yb on 16/9/23.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

//微博的视图模型
class StatusViewModel: NSObject {
    
    var status : Status?
    
    ///微博来源字符串
    var sourceText : String?
    ///微博创建时间的字符串
    var createText : String?
    //用户认证图标
    var verifiedImage : UIImage?
    //用户会员等级图标
    var vipImage : UIImage?
    //头像的URL
    var iconURL : NSURL?
    ///配图的数据
    var picURLs : [NSURL] = [NSURL]()
    

    
    
    init(status : Status) {
        self.status = status
        
        //处理创建时间的字符串
        if let created_at = status.created_at{
            createText = NSDate.creatDateStr(created_at)
        }
        //处理来源字符串
        if let source = status.source where source != ""{
            
            //              source = "<a href=\"http://app.weibo.com/t/feed/l4RWD\" rel=\"nofollow\">Weico.Android</a>";
            //截取字符串
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - startIndex
            sourceText = "来自" + (source as NSString).substringWithRange(NSMakeRange(startIndex, length))
        }
       
        //用户认证图标
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
        case 0:
            verifiedImage = UIImage.init(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage.init(named: "avatar_grassroot")
        default:
            verifiedImage = nil

        }
        //用户会员等级图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank < 7 {
            vipImage = UIImage.init(named: "common_icon_membership_level\(mbrank)")
        }
        
        //头像的URL
        let urlStr = status.user?.profile_image_url ?? ""
        iconURL = NSURL.init(string: urlStr)
        
        ///配图的数据
      /*  
         "pic_urls" =     (
            {
                "thumbnail_pic" = "http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f84jfy74rmg205f08cnpe.gif";
            },
            {
                "thumbnail_pic" = "http://ww1.sinaimg.cn/thumbnail/6aaeb4b8gw1f84jg5gpdlg205f0821l0.gif";
            }
        );
      */
        
        //MARK:- 因为转发微博时不能带图转发，所以在这里跟换配图view的数据源，从而展示不同的配图
        let picDictArr = status.pic_urls?.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        
        if let picDictArr = picDictArr{
            
            for picDict in picDictArr{
//                print("11111")
                //如果取出来的picUrlStr，也要让for循环继续下去，所以这里用continue
                guard let picUrlStr = picDict["thumbnail_pic"] else{
                    continue
                }
                
//                print("22222\(picUrlStr)")
                picURLs.append(NSURL.init(string: picUrlStr)!)
//                print("3333")
                
               /*
                 上面这种guard条件判断，其实就是可选绑定，和下面的逻辑是一样的
                print("11111")
                if let picUrlStr = picDict["thumbnail_pi"] {
                    print("22222\(picUrlStr)")
                    picURLs.append(NSURL.init(string: picUrlStr)!)
                    print("3333")
                }*/

            }
        }
        
        
    }
    

}
