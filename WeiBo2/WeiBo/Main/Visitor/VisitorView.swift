//
//  VisitorView.swift
//  WeiBo
//
//  Created by yb on 16/9/19.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    class func visitorView() -> VisitorView{
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)!.first as! VisitorView
    }
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    func setupVisitorView(_ iconName : String,tip : String){
        rotationView.isHidden = true
        iconView.image = UIImage.init(named: iconName)
        tipLabel.text = tip
    }
    
    
    func addRotationAnimation() {
        let rotation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        
        rotation.fromValue = 0
        rotation.toValue = M_PI * 2
        rotation.repeatCount = MAXFLOAT
        rotation.duration = 7
        rotation.isRemovedOnCompletion = false
        
        rotationView.layer.add(rotation, forKey: nil)
        
    }
}
