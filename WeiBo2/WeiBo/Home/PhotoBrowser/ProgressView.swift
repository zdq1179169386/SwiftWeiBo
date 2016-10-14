//
//  ProgressView.swift
//  WeiBo
//
//  Created by yb on 16/10/12.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    var progress : CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let  startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * progress + startAngle
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //绘制一条中心点的线
        path.addLineToPoint(center)
        path.closePath()
        
        UIColor(white: 1.0, alpha: 0.7).setFill()
        
        path.fill()
        
    }

}
