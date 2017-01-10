
//
//  NSDate-Extension.swift
//  WeiBo
//
//  Created by yb on 16/9/23.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import Foundation

extension Date{
    
    static func creatDateStr(_ creatStr : String) -> String{
        
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        
        guard let creatDate = fmt.date(from: creatStr) else{
            return ""
        }
        
        //获取当前时间
        let now = Date()
        //计算差值秒数
        let interval = Int(now.timeIntervalSince(creatDate))
                
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
        let calendar = Calendar.current
        //昨天
        if calendar.isDateInYesterday(creatDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let str = fmt.string(from: creatDate)
            return str
        }
        
        //一年之内
        
        let cmps = (calendar as NSCalendar).components(.year, from: creatDate, to: now, options: [])
        
        if cmps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let str = fmt.string(from: creatDate)
            return str
        }
        
        //超过一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let str = fmt.string(from: creatDate)
        return str
    }
}
