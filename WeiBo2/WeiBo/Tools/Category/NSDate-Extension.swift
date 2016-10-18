
//
//  NSDate-Extension.swift
//  WeiBo
//
//  Created by yb on 16/9/23.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import Foundation

extension NSDate{
    
    class func creatDateStr(creatStr : String) -> String{
        
        let fmt = NSDateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en")
        
        guard let creatDate = fmt.dateFromString(creatStr) else{
            return ""
        }
        
        //获取当前时间
        let now = NSDate()
        //计算差值秒数
        let interval = Int(now.timeIntervalSinceDate(creatDate))
                
        //一分钟内显示刚刚
        
        if interval < 60 {
            return "刚刚"
        }

        //一小时内显示几分钟前
        
        if interval < (60 * 60) {
            return "\(interval/60)分钟前"
        }
        //一天内显示几小时前
        
        if interval < (60 * 60 * 24) {
            return "\(interval / 3600)小时前"
        }
        //创建日历对象
        let calendar = NSCalendar.currentCalendar()
        //昨天
        if calendar.isDateInYesterday(creatDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let str = fmt.stringFromDate(creatDate)
            return str
        }
        
        //一年之内
        
        let cmps = calendar.components(.Year, fromDate: creatDate, toDate: now, options: [])
        
        if cmps.year < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let str = fmt.stringFromDate(creatDate)
            return str
        }
        
        //超过一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let str = fmt.stringFromDate(creatDate)
        return str
    }
}